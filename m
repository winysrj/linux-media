Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54080 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbZKRPRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 10:17:06 -0500
Received: by yxe17 with SMTP id 17so1067182yxe.33
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 07:17:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B03FEFC.4@infradead.org>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <20091023051025.597c05f4@caramujo.chehab.org>
	 <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
	 <4B02FDA4.5030508@infradead.org>
	 <829197380911171155j36ba858ejfca9e4c36689ab62@mail.gmail.com>
	 <4B032973.60002@infradead.org>
	 <829197380911180132j619a5a02gead3f3f91e68f524@mail.gmail.com>
	 <4B03FEFC.4@infradead.org>
Date: Wed, 18 Nov 2009 10:17:10 -0500
Message-ID: <829197380911180717p6aeeb614ha0a45b22ab90ed2c@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2009 at 9:04 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Devin Heitmueller wrote:
>> On Tue, Nov 17, 2009 at 5:53 PM, Mauro Carvalho Chehab
>> <mchehab@infradead.org> wrote:
>>> We shouldn't write API's thinking on some specific use case or aplication.
>>> If there's a problem with zap, the fix should be there, not at the kernel.
>>
>> Your response suggests I must have poorly described the problem.  Zap
>> is just one example where having an "inconsistent" view of the various
>> performance counters is easily visible.  If you're trying to write
>> something like an application to control antenna orientation, the fact
>> that you cannot ask for a single view of all counters can be a real
>> problem.  Having to make separate ioctl calls for each field can cause
>> real problems here.
>>
>> I disagree strongly with your assertion that we should not considering
>> specific use cases when writing an API.
>
> That's not what I've said (or maybe I haven't said it clear enough).
> I'm saying that we shouldn't look for one particular use case only.
> In other words, the API should cover all use cases that makes sense.
>
>>In this case, Manu's
>> approach provides the ability to get a single consistent view of all
>> the counters (for those drivers which can support it)
>
> No. To get all counters, you'll need to call 3 ioctls. The status were
> grouped around 3 groups of counters on his proposal. I'm sure Manu has some
> explanation why he thinks that 3 is better then 2 or 4 calls, but the point
> is: should we really group them on a fixed way?
>
> Btw, by using S2API, we'll break it into different commands. Yet, we can
> call all of them at once, if needed, as the API defines it as:
>
> struct dtv_property {
>        __u32 cmd;
>        __u32 reserved[3];
>        union {
>                __u32 data;
>                struct {
>                        __u8 data[32];
>                        __u32 len;
>                        __u32 reserved1[3];
>                        void *reserved2;
>                } buffer;
>        } u;
>        int result;
> } __attribute__ ((packed));
>
> struct dtv_properties {
>        __u32 num;
>        struct dtv_property *props;
> };
>
> #define FE_SET_PROPERTY            _IOW('o', 82, struct dtv_properties)
> #define FE_GET_PROPERTY            _IOR('o', 83, struct dtv_properties)
>
> So, all needed commands can be grouped together to provide an atomic read.
>
>>> Also, the above mentioned problem can happen even if there's just one API
>>> call from userspace to kernel or if the driver needs to do separate,
>>> serialized calls to firmware (or a serialized calculus) to get the
>>> three measures.
>>
>> True, the accuracy in which a given driver can provide accurate data
>> is tied to the quality of the hardware implementation.  However, for
>> well engineered hardware, Manu's proposed API affords the ability to
>> accurately report a consistent view of the information.  The existing
>> implementation restricts all drivers to working as well as the
>> worst-case hardware implementation.
>
> Imagining that some application will need to retrieve all quality indicators
> at the same time, as they were grouped into 3 groups, even on a perfect
> hardware, you won't be able to get all of them at the sime time,
> since you'll need to call 3 ioctls.
>
>>>> For what it's worth, we have solved this problem in hwmon driver the
>>>> following way: we cache related values (read from the same register or
>>>> set of registers) for ~1 second. When user-space requests the
>>>> information, if the cache is fresh it is used, otherwise the cache is
>>>> first refreshed. That way we ensure that data returned to nearby
>>>> user-space calls are taken from the same original register value. One
>>>> advantage is that we thus did not have to map the API to the hardware
>>>> register constraints and thus have the guarantee that all hardware
>>>> designs fit.
>>>>
>>>> I don't know if a similar logic would help for DVB.
>>> This could be an alternative, if implemented at the right way. However,
>>> I suspect that it would be better to do such things at libdvb.
>>>
>>> For example, caching measures for 1 second may be too much, if userspace is
>>> doing a scan, while, when streaming, this timeout can be fine.
>>
>> Jean's caching approach for hwmon is fine for something like the
>> chassis temperature, which doesn't change that rapidly.  However, it's
>> probably not appropriate for things like SNR and strength counters,
>> where near real-time feedback can be useful in things like controlling
>> a rotor.
>
> I agree.
>
> Yet, you won't have this feedback in real-time, since calculating
> QoS indicators require some time. So, after moving the rotor, you'll need
> to wait for some time, in order to allow the frontend to recalculate the
> QoS after the movement. There's a problem here, not addressed by none of
> the proposals: when the QoS indicators will reflect the rotor movement?
>
> If you just read the QoS indicator in a register, you're likely getting a
> cached value from the last time the hardware did the calculus.
>
> So, if you really need to know the QoS value after changing the antenna
> position, you'll need to wait for some time before reading the QoS.
>
> This time will likely depend on how the frontend chip QoS logic is
> implemented internally. Also, some indicators are dependent of the bit rate
> (like frame error counters).
>
> Imagining the best case where the developer knows how to estimate this time,
> we would need a way to report this time to userspace or to generate an event
> after having the measure done.
>
>> One more point worth noting - the approach of returning all the
>> counters in one ioctl can actually be cheaper in terms of the number
>> of register read operations.  I've seen a number of drivers where we
>> hit the same register three or four times, since all of various fields
>> are based on the same register.  Having a single call actually allows
>> all the duplicate register reads to be eliminated in those cases, the
>> driver reads the register once and then populates all the fields in
>> one shot based on the result.
>
> True.
>
>> I was actually against Manu's proposal the last time it was put out
>> there, as I felt just normalizing the existing API would be *good
>> enough* for the vast majority of applications.  However, if we have
>> decided to give up on the existing API entirely and write a whole new
>> API, we might as well do it right this time and build an API that
>> satisfies all the people who plan to make use of it.
>
> In general, I don't like to deprecate userspace API's. This means too much
> work for kernel and for userspace developers.
>
> However, in this specific case, there are several cons against
> normalizing the existing API is that:
>
>        1) We will never know the scale used by some drivers. So, on some
> drivers, it will keep representing data at some arbitrary scale;
>
>        2) Reverse-engineered drivers will never have a proper scale, as
> the developer has no way to check for sure what scale is reported by the
> device;
>
>        3) Existing applications might break, since we'll change the
>           scale of existing drivers;
>
>        4) There are no way for applications written after the change to
>           check if that driver is providing the value at the proposed scale;
>
> The beauty of Manu's approach is that it supports all devices, even those
> were we'll never know what scale is used. So, all 4 cons are solved by
> creating a new API.
>
> However, as-is, it has some drawbacks:
>
>        1) arbitrary groups of QoS measures;
>        2) structs are fixed. So, if changes would be needed later, or if more
>           QoS indicators would be needed, we'll have troubles.
>        3) due to (2), it is not future-proof, since it may need to be deprecated
>           if more QoS indicators would need to be added to a certain QoS group.
>
> However, if we port his proposal to S2API approach, we'll have a future-proof
> approach, as adding more QoS is as simple as creating another S2API command.
>
> Cheers,
> Mauro.

If this is an argument about whether to do it with s2api or the older
ioctl interface, I definitely do not have any objection to doing it
with s2api.  All the applications I care about have been ported over,
so the incremental cost of using the new call is minimal, and perhaps
having some reliable quality indicators will prompt some of the
applications that haven't ported to s2api to finally cut over.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
