Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966728AbZLHXnY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 18:43:24 -0500
Message-ID: <4B1EE49A.8030701@redhat.com>
Date: Tue, 08 Dec 2009 21:43:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Julian Scheel <julian@jusst.de>, linux-media@vger.kernel.org
Subject: Re: New DVB-Statistics API
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com> <1a297b360912081346k45b7844bg5d408d47a38da5b4@mail.gmail.com>
In-Reply-To: <1a297b360912081346k45b7844bg5d408d47a38da5b4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:

>> Not true. As pointed at the previous answer, the difference between a new ioctl
>> and S2API is basically the code at dtv_property_prepare_get_stats() and
>> dtv_property_process_get(). This is a pure code that uses a continuous struct
>> that will likely be at L3 cache, inside the CPU chip. So, this code will run
>> really quickly.
> 
> 
> 
> AFAIK, cache eviction occurs with syscalls: where content in the
> caches near the CPU cores is pushed to the outer cores, resulting in
> cache misses. Not all CPU's are equipped with L3 caches. Continuous
> syscalls can result in TLB cache misses from what i understand, which
> is expensive.

It is very likely that the contents of struct fe to go into the cache during the
syscall. I was conservative when I talked about L3. Depending on the cache sizes,
I won't doubt that the needed fields of the fe struct will go to L1 cache.

>> As current CPU's runs at the order of Teraflops (as the CPU clocks are at gigahertz
>> order, and CPU's can handle multiple instructions per clock cycle), the added delay
>> is in de order of nanosseconds.
> 
> 
> Consider STB's where DVB is generally deployed rather than the small
> segment of home users running a stack on a generic PC.

Even with STB, let's assume a very slow cpu that runs at 100 Megabytes/second. So, the clock
speed is 10 nanoseconds. Assuming that this CPU doesn't have a good pipeline, being
capable of handling only one instruction per second, you'll have one instruction at executed
at each 10 nanoseconds (as a reference, a Pentium 1, running at 133 Mbps is faster than this).

An I/O operation at i2c is of the order of 10^-3. Assuming that an additional delay of 10%
(10 ^ -4) will deadly affect realtime capability (with it is very doubtful), this means that
the CPU can run up to 10,000 (!!!) instructions to generate such delay. If you compile that code
and check the number or extra instructions I bet it will be shorter enough to not cause any
practical effect.

So, even on such bad hardware that is at least 20x slower than a netbook running at 1Gbps,
what determines the delay is the amount of I/O you're doing, and not the number of extra
code.

 > Hardware I/O is the most expensive operation involved. 

True. That's what I said.

> Case #1: the ioctl approach
	<code stripped>
>
> Now Case #2: based on s2api
	<code stripped>

> Now that we can see the actual code flow, we can see the s2api
> approach requires an unnecessary large tokenizer/serializer, involving
> multiple function calls.

Are you seeing there 10.000 assembler instructions or so? If not, the size of the code is
not relevant. 

Also: gcc optimizer transforms switches into a binary tree. So, if you have 64
cases on switch, it will require 7 comparations (log2(64)) to get a match.

For example, a quick look at the code you've presented, let's just calculate
the number of operations on the dtv_property_proccess_get() routine, without
debug stuff:

static int dtv_property_process_get() {
	CMP (if fe->ops.get_property)
	CMP (if r < 0)                   <==== This if only happens if the first one is executed. On my patch, it is not executed
						(the code you posted is the one before my patch)
	SWITCH (7 CMP's)		 <==== due to binary tree optimization done by gcc
	MOV
}

So, that entire code (that has about 200 lines) has, in fact
9 comparations and one move instruction.

At dtv_property_prepare_get_stats(), the code is even cheaper: just a switch with 8
elements (log2(8) = 3), so 3 comparations, and one move instruction.

The additional cost on dvb_frontend_ioctl_properties is:
	2 MOVs
	One loop calling dtv_property_prepare_get_stats() - up to 4 times to retrieve
all quality values
	one INC
	one CMP and function CALL (the same cost exists also with the struct)
	One loop calling dtv_property_get_stats() - up to 4 times to retrieve
all quality values

So, if I've calculated it right, we're talking about 2+1+16+1+2+1+40 = 63 instructions.

So, the real executed code is very cheap. On that very slow CPU, the delay will be
about 63 x 10 nanosseconds = 630 nanosseconds of delay (being 220ns before the
call and 410ns after it).

This means 0.063% of a delay at the order of milisseconds required just one
I2C read (and, in general, you need more than one single read to get the stats).

Even if the code would double the size, the latency won't be affected.

> Aspect #1. Comparing Case #1 and Case #2, i guess anyone will agree
> that case 2 has very much code overhead in terms of the serialization
> and serialization set/unset.

It has some overhead, but if you are concerned about the realtime case, 
just run kernel perf tools. You'll see my point. If you have less I/O
to do (to retrieve just the data you need), Case #2 is much faster than Case #1.

> Aspect #2, Comparing the data payload between Case #1 and Case #2, i
> guess anyone can see the size of the data structure and come to a
> conclusion without a second thought that case #2 has many many times
> the payload size as in Case #1

True. Payload is bigger, but not that big. The payload is the data that
comes from the kernel API to the driver and vice versa (payload is defined
as the amount of data is used to pass information from one layer to
another).

> Also there is no guarantee that all these function calls are going to
> give you "in-sync" statistics data for real time applications.

Why not? The guarantee is equal on both cases, since it will depend on how
the callback is written. The extra delay of 410 nanoseconds won't be
enough to cause any change on it.
 
> Now: We are talking about a small system such as a STB where this is
> going to run.
> 
> Signal statistics are polled continuously in many applications to
> check for LNB drift etc (some of the good applications do that).
> Statistics are not just used alone to display a signal graph alone.
> These STB's have very small CPU's in the order of 400MHz etc,

Good! 4 times faster than my example, if the CPU can run one
instruction per cycle. 

So, the delay after the call is 102.5 ns on this CPU.

> but not
> as one sees in a regular PC in the order of a few GHz and teraflop
> operations. There are still smaller applications, what I am pointing
> out here is a large majority of the small CPU user segment.
> 
> Another example is a headless IPTV headend. Small CPU's on it too..
> 
> Another example of a continuous polling is a gyro based setup where a
> rotor controls the antenna position, the position of which is based
> from the RF signal in question. Syscalls rates are considerably higher
> in this case.

Very likely, you won't need to get all 4 stats on this example. So, S2API
will be faster, since a single read at ms is 9756 x slower than 102.5 ns.

> As you can see, the serializer/tokenizer approach introduces an
> unwanted/redundant additional load.

> Other than that, we don't have numerous parameters that we are in need
> of a serializer to handle 4 parameters. 4 x 4bytes.
> 
> 
> Now, let me get back to your cx24123 example.
> 
> +static int cx24123_get_stats(struct dvb_frontend* fe)
> +{
> +       struct cx24123_state *state = fe->demodulator_priv;
> +       struct dtv_frontend_properties *prop = &fe->dtv_property_cache;
> +
> +       if (fe->dtv_property_cache.need_stats & FE_NEED_STRENGTH) {
> +               /* larger = better */
> +               prop->strength = cx24123_readreg(state, 0x3b) << 8;
> +                       dprintk("Signal strength = %d\n", prop->strength);
> +               fe->dtv_property_cache.need_stats &= ~FE_NEED_STRENGTH;
> +       }
> +
> +       if (fe->dtv_property_cache.need_stats & FE_NEED_STRENGTH_UNIT) {
> +               /* larger = better */
> +               prop->strength_unit = FE_SCALE_UNKNOWN;
> +               fe->dtv_property_cache.need_stats &= ~FE_NEED_STRENGTH_UNIT;
> +       }
> +
> +       if (fe->dtv_property_cache.need_stats & FE_NEED_ERROR) {
> +               /* The true bit error rate is this value divided by
> +               the window size (set as 256 * 255) */
> +               prop->error = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
> +                              (cx24123_readreg(state, 0x1d) << 8 |
> +                              cx24123_readreg(state, 0x1e));
> +
> +               dprintk("BER = %d\n", prop->error);
> +
> +               fe->dtv_property_cache.need_stats &= ~FE_NEED_ERROR;
> +       }
> +
> +       if (fe->dtv_property_cache.need_stats & FE_NEED_ERROR_UNIT) {
> +               /* larger = better */
> +               prop->strength_unit = FE_ERROR_BER;
> +               fe->dtv_property_cache.need_stats &= ~FE_NEED_ERROR_UNIT;
> +       }
> +
> +       if (fe->dtv_property_cache.need_stats & FE_NEED_QUALITY) {
> +               /* Inverted raw Es/N0 count, totally bogus but better than the
> +                  BER threshold. */
> +               prop->quality = 65535 - (((u16)cx24123_readreg(state,
> 0x18) << 8) |
> +                                         (u16)cx24123_readreg(state, 0x19));
> +
> +               dprintk("read S/N index = %d\n", prop->quality);
> +
> +               fe->dtv_property_cache.need_stats &= ~FE_NEED_QUALITY;
> +       }
> +
> +       if (fe->dtv_property_cache.need_stats & FE_NEED_QUALITY_UNIT) {
> +               /* larger = better */
> +               prop->strength_unit = FE_QUALITY_EsNo;
> +               fe->dtv_property_cache.need_stats &= ~FE_NEED_QUALITY_UNIT;
> +       }
> +
> +       /* Check if userspace requested a parameter that we can't handle*/
> +       if (fe->dtv_property_cache.need_stats)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> 
>  /*
>  * Configured to return the measurement of errors in blocks,
>  * because no UCBLOCKS value is available, so this value doubles up
> @@ -897,43 +957,30 @@ static int cx24123_read_status(struct dv
>  */
>  static int cx24123_read_ber(struct dvb_frontend *fe, u32 *ber)
>  {
> -       struct cx24123_state *state = fe->demodulator_priv;
> +       fe->dtv_property_cache.need_stats = FE_NEED_ERROR;
> +       cx24123_get_stats(fe);
> 
> -       /* The true bit error rate is this value divided by
> -          the window size (set as 256 * 255) */
> -       *ber = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
> -               (cx24123_readreg(state, 0x1d) << 8 |
> -                cx24123_readreg(state, 0x1e));
> -
> -       dprintk("BER = %d\n", *ber);
> -
> +       *ber = fe->dtv_property_cache.error;
>        return 0;
>  }
> 
>  static int cx24123_read_signal_strength(struct dvb_frontend *fe,
>        u16 *signal_strength)
>  {
> -       struct cx24123_state *state = fe->demodulator_priv;
> -
> -       /* larger = better */
> -       *signal_strength = cx24123_readreg(state, 0x3b) << 8;
> -
> -       dprintk("Signal strength = %d\n", *signal_strength);
> -
> +       fe->dtv_property_cache.need_stats = FE_NEED_STRENGTH;
> +       cx24123_get_stats(fe);
> +       *signal_strength = fe->dtv_property_cache.strength;
>        return 0;
>  }
> 
> +
>  static int cx24123_read_snr(struct dvb_frontend *fe, u16 *snr)
>  {
> -       struct cx24123_state *state = fe->demodulator_priv;
> -
>        /* Inverted raw Es/N0 count, totally bogus but better than the
> -          BER threshold. */
> -       *snr = 65535 - (((u16)cx24123_readreg(state, 0x18) << 8) |
> -                        (u16)cx24123_readreg(state, 0x19));
> -
> -       dprintk("read S/N index = %d\n", *snr);
> -
> +               BER threshold. */
> +       fe->dtv_property_cache.need_stats = FE_NEED_QUALITY;
> +       cx24123_get_stats(fe);
> +       *snr = fe->dtv_property_cache.quality;
>        return 0;
>  }
> 
> 
> Now, in any of your use cases, you are in fact using the same number
> of I2C calls to get a snapshot of statistics in any event of time, as
> in the case of the ioctl approach. So you don't get any benefit in
> using the s2api approach for I2C operation I/O time periods.

Not true.

If userspace requires only strength, 

fe->dtv_property_cache.need_stats will be equal to FE_NEED_STRENGTH
and only one hardware I/O operation will occur:
 
	prop->strength = cx24123_readreg(state, 0x3b) << 8;

If userspace requires both strength and ber,

fe->dtv_property_cache.need_stats = FE_NEED_QUALITY | FE_NEED_STRENGTH, and
the code will run the following I/O:

	prop->strength = cx24123_readreg(state, 0x3b) << 8;
        prop->ber = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
                     (cx24123_readreg(state, 0x1d) << 8 |
                      cx24123_readreg(state, 0x1e));

If the user requires all 3 stats, then we'll have:

	prop->strength = cx24123_readreg(state, 0x3b) << 8;
        prop->ber = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
                     (cx24123_readreg(state, 0x1d) << 8 |
                      cx24123_readreg(state, 0x1e));
        prop->quality = 65535 - (((u16)cx24123_readreg(state, 0x18) << 8) |
                                 (u16)cx24123_readreg(state, 0x19));

Only in the last case, the delay will be equal to the one you would get with
Case #1 (since the delay will be determined by the 100 KHz I2C clock, and
not by the 400 MHz CPU clock).

> The only additional aspect that you draw in using a serializer (when
> using s2api) spread out over multiple function calls, in such a fast
> call use case is that, you add in the ambiguity of the time frame in
> which the completed operation is presented back to the user.

There's only one function call: the call to cx24123_get_stats().
the other "calls" at dvb core are converted into a single function by
gcc optimizer (as they are static and are called only once inside the code).

> So eventually, we need to consider using timing related information
> sent back to the user to compensate for an ambiguous latency involved,
> which makes things even more complex, ugly and unwieldy for fast and
> small applications.
> 
>> The only cons I can think is that the S2API payload for a complete retrival of all
>> stats will be a little bigger.
> 
> Yeah, this is another one of the side effects of using s2api, 16 bytes
> in comparison to > 300 bytes

It seems that you didn't made the right calculus here. There are two payloads envolved:

1) the callback to the driver:

Case #1:
static int cx24123_get_stats(struct dvb_frontend* fe)


Case #2:
static int stb0899_read_stats(struct dvb_frontend *fe, struct fesignal_stat *stats)

payload of case #2 is 4 bytes bigger.

2) the userspace->kernelspace payload. 

Case #1: The size of S2API structs. It will range from 24 to 84 (depending on what
you want to get, from one to 4 different value pairs).

Case #2: The size of the ioctl struct: about 30 bytes (If I summed the size of all structs correctly).

payload of S2API is generally bigger, except if just one parameter is required. 

The size of the S2API cache struct doesn't matter here, as it is part of "struct fe", so
it is present anyway.

Cheers,
Mauro.
