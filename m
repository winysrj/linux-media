Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab3AONLW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 08:11:22 -0500
Date: Tue, 15 Jan 2013 11:10:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130115111041.6b78a935@redhat.com>
In-Reply-To: <50F522AD.8000109@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<50F522AD.8000109@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Jan 2013 11:34:37 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 01/15/2013 04:30 AM, Mauro Carvalho Chehab wrote:
> 
> >      v6: Add DocBook documentation.
> >      v7: Some fixes as suggested by Antti
> >      v8: Documentation fix, compilation fix and name the stats struct,
> >          for its reusage inside the core
> >      v9: counters need 32 bits. So, change the return data types to
> >          s32/u32 types
> >      v10: Counters changed to 64 bits for monotonic increment
> > 	 Don't create a separate get_stats callback. get_frontend
> > 	 is already good enough for it.
> 
> Is there way to return BER as rate, or should it be calculated by the 
> application (from total and error bit counts)?

I don't think it makes sense to let such calculus happen inside Kernel.
It is very easy for userspace to get both numbers at the same ioctl call,
convert from u64 to float and do a float point division in userspace.

In order to handling tose two u64 numbers in kernelspace, the math will
be tricky to avoid overflow. It would also require some scale for BER,
as BER is always a fractional number, generally expressed in E-06 or E-09.

> You seems to change value to 64 bit already, which is enough. 32bit is 
> absolutely too small, it will overflow in seconds (practically around 
> 10sec when there is radio channel of 32MHz and quite optimal conditions).

Yes, 32 bits can cause overflow very quick.

> It is 64bit returned to userspace, is it?

Yes.

> Does 64bit calculations causes any complexity of Kernel or app space?

On the Kernel side, nothing complex was introduced on the frontend I
added it. See the mb86a20s_get_stats function there:
	http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/stats:/drivers/media/dvb-frontends/mb86a20s.c#l934

The logic that fills it is here, at line 953:
	...
	rc = mb86a20s_get_ber_before_vterbi(fe, i, &bit_error, &bit_count);
	if (rc >= 0) {
		c->bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
		c->bit_error.stat[1 + i].uvalue += bit_error;
		c->bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
		c->bit_count.stat[1 + i].uvalue += bit_count;
	...

What it was a little more complex were the calculus of a "global" BER measure
for the (up to) 3 layers. I rewrote that code a few times, until I got
satisfied with it. The thing is that, as each layer works like an independent
channel, the BER measure for each layer happens on a different moment.

So, I was in doubt if total BER measure should wait for all layer stats to
be measured or if it should start to appear when the first layer starts to
have statistics. I decided for the second.

On the userspace, I did just a very quick hack at late night yesterday
in order to be able to better see the statistics measures together.
I don't expect any problem to handle those measures there through.
As you can see, the patch that gets all stats is very simple:

	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/commitdiff/fffeedfd683033c3d97e0b8c781e7486203a0568

What it is missed there is to do the division to convert bit error into BER,
and a logic that would display "dB" or "dBm" if the signal strength/CNR
measures are scaled in dB.

Btw, I'm even in doubt if we should implement the stats ENUM property.
Currently, all unsupported properties are returned with len=0. So, I don't
see any need to have a separate ioctl for that. Perhaps we can just get
rid of it, in order to simplify the API.

Displaying the per-layer stats there can be a little tricky. It probably
only makes sense to display one layer at dvbv5-zap application: the layer
that matches the filtered channel. I need to investigate a little more to
check how to do such match. Maybe the dvbv5-scan application will need to
be able to parse some MPEG descriptor to get such data.

> Basically, that API is more complex that I would like to see, but I can 
> live with it. I still fear making too complex API causes same problems 
> as we has currently... lack of app support.

While coding both drivers and userspace, I didn't fill it to be complex.
At kernelspace, all it was needed were to fill the len for those stats
measures that would be used. Then, to fill the value and the scale when
the measure get available, or to mark them as unavailable, if they
disappear (for example, broadcaster may dynamically change the layers
layout, so one layer measure could disappear at runtime).

at userspace, just one ioctl is enough to get all stats:

	dvb_prop[0].cmd = DTV_QOS_SIGNAL_STRENGTH;
	dvb_prop[1].cmd = DTV_QOS_CNR;
	dvb_prop[2].cmd = DTV_QOS_BIT_ERROR_COUNT;
	dvb_prop[3].cmd = DTV_QOS_TOTAL_BITS_COUNT;
	dvb_prop[4].cmd = DTV_QOS_ERROR_BLOCK_COUNT;
	dvb_prop[5].cmd = DTV_QOS_TOTAL_BLOCKS_COUNT;
	props.num = 6;
	props.props = dvb_prop;

	if (ioctl(parms->fd, FE_GET_PROPERTY, &props) == -1)
		perror("FE_GET_PROPERTY");

A simple display mechanism to display all values would be this one:

	for (i = 0; i < 6; i++) {
		for (j = 0; j < dvb_prop[i].u.st.len; j++) {
			if (dvb_prop[i].u.st.stat[j].scale != FE_SCALE_NOT_AVAILABLE)
				printf("%s[%d] = %u\n", dvb_v5_name[dvb_prop[i].cmd], j, (unsigned int)dvb_prop[i].u.st.stat[j].uvalue);
		}
	}

Or, if just the global value is enough:

	for (i = 0; i < 6; i++) {
		if (dvb_prop[i].u.st.stat[0].scale != FE_SCALE_NOT_AVAILABLE)
			printf("%s = %u\n", dvb_v5_name[dvb_prop[i].cmd], (unsigned int)dvb_prop[i].u.st.stat[0].uvalue);
	}


Of course, for BER, we would do, instead:

double BER = ((double)dvb_prop[i].u.st.stat[2].uvalue) / dvb_prop[i].u.st.stat[5].uvalue;

-- 

Cheers,
Mauro
