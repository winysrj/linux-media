Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ke12Y-0005Or-Ol
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 07:17:59 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K72001J2HCVXHV0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 12 Sep 2008 01:17:20 -0400 (EDT)
Date: Fri, 12 Sep 2008 01:17:19 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48C91EA0.7080207@linuxtv.org>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48C9FB5F.80300@linuxtv.org>
MIME-version: 1.0
References: <48C72F99.20501@linuxtv.org> <48C91EA0.7080207@linuxtv.org>
Subject: Re: [linux-dvb] S2API - Code review and suggested changes (1)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Steven Toth wrote:
> Steven Toth wrote:
>>
>> Hello!
>>
>> Here's the feedback collected from various people. Thank you! I've 
>> indented their comments and replied directly inline but more 
>> suggestions and potential changes.
>>
>> * Johannes:
>> *
>> * OK can't help myself to give a few techical remarks:
>> *
>> * - I'm not sure because I don't have a 64bit platform but I
>> *   think tv_property_t has different size on 64bit due to
>> *   alignment? Please check, to avoid compat_ioctl
>> *
>> * - typedefs? hm, I guess to match the style of the existing code...
>>
>> Looking at the CodingStyle section on typedefs, it tries to discourage 
>> their use.
>> It probably makes sense to switch to result structs.
> 
> Done.
> 
>>
>> tv_property_t type becomes struct dtv_property.
>>
>> *
>> * - why both FE_SET_PROPERTY/FE_GET_PROPERTY and
>> * TV_SET_FREQUENCY/TV_GET_FREQUENCY etc?
>> *
>>
>> If I understand correctly then I think the suggestion is 
>> FE_SET_PROPERTY(TV_FREQUENCY, ...)
>> makes more sense. Han's also touched on this. I think I agree, 
>> removing the notion of SET/GET
>> from the command name is cleaner, less confusing.


This is now done.


>>
>> * - instead of "typedef tv_property_t tv_properties_t[16];" and the
>> *   TV_SEQ_* things why not
>> *      typedef struct {
>> *          __u32 num;
>> *          tv_property_t *props;
>> *      } tv_properties_t;
>> *    and then copy_from_user() an arbitrary number of properties?
>> *    But its all a matter of taste and if it works is find by me.
>>
>> Perfect sense, I'll change this, it will become
>>
>>       struct dtv_properties {
>>           __u32 num;
>>           dtv_property *props;
>>       };
> 
> 
> I varied this slightly to accomodate some reserved fields, but it's 
> done. The 16 command restriction is removed.
> 
> I've placed #define in frontend.h making a 64 command restriction, else 
> the handing in dvb_frontend.c could become unsafe. This matches similar
> limits placed on the i2c-dev.c and video-ioctl.c similar variable length
> handling schemes.
> 
> 
>>
>>
>> * Patrick:
>> *
>> * I think it would be better to change TV_ to FE_ (because TV is by
>> * far not
>> * the only application for linux-dvb) , but this is a very unimportant
>> * detail.
>>
>> A few people prefer dtv_ and DTV_, rather than tv_ and TV_. is fe_
>> and FE_ still important to you?
> 
> 
> Done.
> 
> 
>>
>>
>> * Hans:
>> *
>> * I noticed that the properties work very similar as to how extended
>> * controls work in v4l:
>> * http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-si
>> * ngle/v4l2.html#VIDIOC-G-EXT-CTRLS
>> *
>> * It might be useful to compare the two.
>>
>> Yes - similar concepts, I'll read further.
>>
>> Last year, Mauro has suggested we also consider the VIDIOC_QUERYCTRL, 
>> VIDIOC_QUERYMENU ioctls,
>> giving the applications to ability to query supported functions on a 
>> given demodulator.
>>
>> *
>> * I would recommend adding a few reserved fields, since that has
>> * proven to be very useful in v4l to make the API more future proof.
> 
> Done.
> 
>>
>> Good point, __u32 and __u64's could be added.
>>
>> struct dtv_property {
>>     __u32 cmd;
>>     __u64 reserved1;
>>     __u64 reserved2;
>>     __u64 reserved3;
>>     __u64 reserved4;
>>     union {
>>         __u32 data;
>>         struct {
>>             __u8 data[32];
>>             __u32 len;
>>         } buffer;
>>     } u;
>> };
>>
>> Question: Is their significant penalties for switching completely from 
>> __u32 to __u64 now?
>> Is this something that should be done completely in this struct, or 
>> are __u32 types less
>> problematic?
> 
> 
> This remains unanswered.
> 
> 
>>
>> This feels perhaps a little too heavy handed, I'd welcome comments on 
>> the types and
>> number of entries.
>>
>> *
>> * Also: is setting multiple properties an atomic action? E.g. if one
>> * fails, are all other changes rolled back as well? And how do you give
>> * the caller feedback on which property in the list failed? Will there
>> * also be a TRY_PROPERTIES variant which just checks for correctness
>> * without actually setting it? How do you query/test whether a
>> * device has certain properties?
>>
>> Atomic vs non-atomic.
>>
>> That's a level of complexity that leads easily to confusion, and we 
>> should avoid. The code we have working today assumes that that 
>> set_frontend() on the demodulators is called when the TV_SET_FREQUENCY 
>> or TV_SEQ_COMPLETE are passed. I think removing the notion of begin 
>> and end sequence, in favour of short structures is less confusing and 
>> less code to maintain in the dvb-core.
>>
>> What's does this translate into for application developers? Well, a 
>> tune request may look something like:
>>
>> properties {
>>     { MODULATION, QAM64)}
>>     { INVERSION, ON)}
>>     { SET_FREQUENCY, 474000000)}
>>     { TUNE }
>> };

This is now done.

>>
>> All of the commands prior to TUNE are cache in the dvb-core, TUNE 
>> explicitly results in a call to set_frontend();
>>
>> The odd item to note is satellite tuning, where certain commands need 
>> to be done immediatly. SET_VOLTAGE or SET_TONE, or DiSEqC related 
>> commands.
>>
>> So, passing SET_VOLTAGE commands would likely execute immediately. I 
>> don't know whether this is a good or bad thing, without spending a lot 
>> of time reviewing our existing dvb-core code. In some respects, the 
>> current in-kernel API expects multiple ioctls to occurs for satellite 
>> tuning to take effect. This (hopefully) will turn that into a single 
>> ioctl.
>>
>> Summary: This would allow the applications to call set/get properties 
>> on cache values, without them being committed to hardware, or directly 
>> committed depending on the type of tuning system and delivery system 
>> being used. An Important fact for any documentation.
> 
> Partially done, the notion of SEQ has been removed. The switch to remove 
> GET/SET is remaining.

This is now done.

> 
>>
>> *
>> * Do you need separate get and set commands? Why not either set or get a
>> * list of properties, and setting them implies an automatic SEQ_COMPLETE
>> * at the end. By having a variable length array of properties you do not
>> * need to set the properties in multiple blocks of 16, so that
>> * simplifies the API as well.
>>
>> Correct, this is going to change to a variable length array.
> 
> Done, as mentioned above.
> 
>>
>> *
>> * As I said, extended controls in v4l do something very similar.
>> * I thought about the extended controls a great deal at the time, so
>> * it might provide a handy comparison for you.
>>
>> Thanks.
>>
>> * Christophe:
>> *
>> * P.S.
>> * 1) imho, DTV_ prefix would make more sense.
>>
>> Understood.
>>
>> * Andreas:
>> *
>> * Regarding the code:
>> * 1) What's TV_SEQ_CONTINUE good for? It seems to be unused.
>>
>> It was going to allow unforseen long command structure to be passed to 
>> the kernel. It's since been superseeded and will be removed.
>>
>> *
>> * 2) Like Christophe I'd prefer to use DTV_ and dtv_ prefixes.
>>
>> Understood.
>>
>> *
>> * 3) Did you mean p.u.qam.modulation below? Also, p.u.qam.fec_inner is
>> * missing.
>> *
>> * +        printk("%s() Preparing QAM req\n", __FUNCTION__);
>> * +        /* TODO: Insert sanity code to validate a little. */
>> * +        p.frequency = c->frequency;
>> * +        p.inversion = c->inversion;
>> * +        p.u.qam.symbol_rate = c->symbol_rate;       * +        
>> p.u.vsb.modulation = c->modulation;
>>
>>
>> Yes, typo, thanks for mentioning this. I'll fix this.
> 
> 
> Not done yet.

This has now changed, cleaner code, more readable and easier to maintain.

> 
> 
>>
>>
>> *
>> * 4) About enum tv_cmd_types:
>> *
>> * SYMBOLRATE -> SYMBOL_RATE?
>> * INNERFEC -> INNER_FEC (or FEC)?
> 
> Done.
> 
>>
>> OK, this was inconsistent. This will change to SYMBOL_RATE and INNER_FEC.
>>
>> *
>> * The Tone Burst command got lost (FE_DISEQC_SEND_BURST). How about
>> * TV_SET_TONE_BURST?
>> *
>> * FE_ENABLE_HIGH_LNB_VOLTAGE got lost, too.
>> *
>> * Which old ioctls should be considered as obsolete? Do you plan to
>> * add a tv_cmd for every old ioctl?
>>
>> SET_TONE and SET_VOLTAGE was added late last week, and appear to be 
>> working correctly. If I've miss-understood the implementation then we 
>> can review/refine again until it makes sense.
>>
>>
>> * Janne:
>> *
>> * I have also a slightly preference for DTV/dtv as prefix but it's not
>> * really important.
>>
>> Understood.
>>
>> *
>> *
>> * >> 16 properties per ioctl are probably enough but a variable-length
>> * >> > > property array would be safe. I'm unsure if this justifies a 
>> more
>> * >> > > complicate copy from/to userspace in the ioctls.
>> * > >
>> * > > Johannes suggested we lose the fixed length approach and instead 
>> pass
>> * > > in struct containing the number of elements... I happen to like 
>> this,
>> * > > and it removed an unnecessary restriction.
>> *
>> * That's the same V4L2 handles the extended controls. For reference look
>> * at VIDIOC_[G|S|TRY]_EXT_CTRLS in v4l2-ioctl.c.
>>
>>
>> I think makes a lot of sense (when used along with _QUERYMENU). It 
>> allows application developers to build tools like v4l2ctl which can 
>> tweak frontend behaviour.
>>
>> I don't know whether change dtv_property to match v4l2_ext_control 
>> makes much sense, but the spirit of the API is strong, and should 
>> probably be carried forward into any new digital TV API.
>>
>> Let me look into this.
> 
> No investigation done yet.

The variable length arrays now use a similar technique to the v4l2 and
i2c subsystems. QUERYMENU doesn't exist, and I'd welcome comments about
whether we need it for a first slice of the S2API in the kernel.

I think we can add this with zero API changes, new command types only.

> 
>>
>> Summary, what do we do next?
>>
>> I'm going to make some patches for the structure changes, reserved 
>> fields, typedefs, nomenclature and generate a tree (and tune.c) for 
>> review/test.
> 
> That's done.
> 
>>
>> That will leave the EXT_CTRLS discussion for further debate, and any 
>> other items that are raised during this review and round of discussions.
>> We will address these in round 2.
> 
> Todo, along with bandwidth suggestions form Patrick.

EXT_CTRLS / QUERYMENU is not implemented, again I'd welcome feedback on
this.

> 
>>
>> I welcome your feedback.
>>
>> - Steve
>>
> 
> 

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
