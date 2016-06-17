Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56469 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbcFQLJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 07:09:21 -0400
Subject: Re: [PATCHv16 08/13] DocBook/media: add CEC documentation
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
 <1461937948-22936-9-git-send-email-hverkuil@xs4all.nl>
 <20160616180958.03b9d759@recife.lan> <5763ADBD.3050502@xs4all.nl>
 <20160617065028.7410ae46@recife.lan>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Hans Verkuil <hansverk@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5763DA56.20402@xs4all.nl>
Date: Fri, 17 Jun 2016 13:09:10 +0200
MIME-Version: 1.0
In-Reply-To: <20160617065028.7410ae46@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2016 11:50 AM, Mauro Carvalho Chehab wrote:
>>>> +	  <row>
>>>> +	    <entry><constant>CEC_MODE_MONITOR</constant></entry>
>>>> +	    <entry>0xe0</entry>
>>>> +	    <entry>Put the file descriptor into monitor mode. Can only be used in combination
>>>> +	    with <constant>CEC_MODE_NO_INITIATOR</constant>, otherwise &EINVAL; will be
>>>> +	    returned. In monitor mode all messages this CEC device transmits and all messages
>>>> +	    it receives (both broadcast messages and directed messages for one its logical
>>>> +	    addresses) will be reported. This is very useful for debugging.</entry>
>>>> +	  </row>
>>>> +	  <row>
>>>> +	    <entry><constant>CEC_MODE_MONITOR_ALL</constant></entry>
>>>> +	    <entry>0xf0</entry>
>>>> +	    <entry>Put the file descriptor into 'monitor all' mode. Can only be used in combination
>>>> +            with <constant>CEC_MODE_NO_INITIATOR</constant>, otherwise &EINVAL; will be
>>>> +            returned. In 'monitor all' mode all messages this CEC device transmits and all messages
>>>> +            it receives, including directed messages for other CEC devices will be reported. This
>>>> +	    is very useful for debugging, but not all devices support this. This mode requires that
>>>> +	    the <constant>CEC_CAP_MONITOR_ALL</constant> capability is set, and depending on the
>>>> +	    hardware, you may have to be root to select this mode.</entry>  
>>>
>>> Please mention the error codes when it fails.  
>>
>> Ack.
>>
>>> "and depending on the hardware, you may have to be root to select this mode."
>>>
>>> No. We should define if CAP_SYS_ADMIN (or maybe CAP_NET_ADMIN, with
>>> is required to set promiscuous mode for network) will be required or
>>> not and enforce it for all hardware.  
>>
>> Ack for CAP_SYS_ADMIN (or possible NET_ADMIN, I'll look into that).
> 
> Thanks.
> 
>>> IMHO, putting the device into monitor mode should require it.  
>>
>> No. The CEC 2.0 spec explicitly recommends that the CEC adapter should be able to
>> monitor all messages.
> 
> What the hardware should or should not do is one thing. The other
> thing is what permissions are needed in order to use such
> feature.
> 
> I don't doubt that a similar requirement exists on 802.x, or on some
> industry standard document requiring that all Ethernet hardware should 
> support promiscuous mode. Yet, for security reasons, enabling such feature 
> requires special caps on Linux.
> 
>> The problem is that 1) not all hardware supports this, and 2)
>> hardware that does support this tends to mention that it is for testing only and
>> it shouldn't be used otherwise.
>>
>> If the hardware is fine with allowing monitoring of all messages, then anyone
>> should be able to do that. 
> 
> Why?

The spec recommends that this is supported in order for applications to take advantage
of seeing such traffic to optimize their performance (i.e. by sniffing traffic you can see which
devices are there so you don't have to discover them). The underlying reason is that
the CEC bus is so hopelessly slow, so any mechanism that helps avoids having to use
the bus is good.

>From the HDMI 2.0 spec (section 11.4):

"Polling can and should be skipped if other CEC traffic shows that a device is present.
 Hence, a device should not poll a certain Logical Address within at least one Minimum
 Polling Period after the following CEC events occur between the device that is polling
 and the device whose Logical Address is to be polled:

 - A directly addressed message, sent to that Logical Address, was acknowledged.
 - A directly addressed message has been sent from that Logical Address.
 - A broadcast message has been sent from that Logical Address.

 It is recommended that, if the device is capable of monitoring CEC traffic directed to
 other devices, then this capability should also be used to further reduce the need for polling.
 In this case, such a device should not poll a certain Logical Address for at least one
 Minimum Polling Period after it detects that that Logical Address acknowledged a directed
 message initiated from any Logical Address, or any message was sent from that Logical Address."

I wouldn't have required CAP_*_ADMIN at all if it wasn't for the scary language in some of the
hardware specs that I have seen.

(see below before replying to this :-) )

> 
>> But if it comes with all these 'for testing only' caveats,
>> then I think it should should be protected against 'casual' use. Unfortunately they
>> never tell you why it should be used for testing only (overly cautious or could
>> something actually fail when in this mode?).
>>
>> The reality is that being able to monitor the CEC bus is extremely useful when debugging.
> 
> Well, it can be debugged as root. That's not an issue. The issue
> here is if sniffing the traffic by a normal user could leak
> something that should not usually be seen by a normal user, like
> a Netflix password, that was typed via the RC, for example.

Interesting example. I hadn't thought of that.

OK, so I'm going to change the code so CAP_SYS/NET_ADMIN is required for the
monitoring mode. It can always be relaxed later, but this password sniffing
example is quite convincing actually.

The HDMI 2.0 polling recommendation can still be met since this would be handled
in the CEC framework (not implemented today, but it is planned since it is fairly
easy to do so). Since that's all inside the kernel nothing is leaked to non-root
applications.

One area where I am uncertain is when remote control messages are received and
passed on by the framework to the RC input device.

Suppose the application is the one receiving a password, then that password appears
both in the input device and the cec device. What I think will be useful is if the
application can prevent the use of an input device to pass on remote control messages.

CEC_ADAP_S_LOG_ADDRS has a flags field that I intended for just that purpose.

Note that RC messages are always passed on to CEC followers even if there is an
input device since some RC messages have additional arguments that the rc subsystem
can't handle. Also I think that it is often easier to handle all messages from the
same CEC device instead of having to read from two devices (cec and input). I
actually considered removing the input support, but it turned out to be useful in
existing video streaming apps since they don't need to add special cec support to
handle remote control presses.

Question: is there a way for applications to get exclusive access to an input device?
Or can anyone always read from it?

So I am thinking that I add a flag to inhibit the use of the input device if set.

This would be in a follow-on patch and it's added to the TODO file in the initial
patch series.

Comments?

>> The simple MONITOR mode is different in that it requires no special hardware configuration.
>> But it won't be able to see directed messages between CEC devices other than us.
>>
>> On a related note: if an application tries to become initiator or follower and someone
>> else has already exclusive access, then EBUSY is returned. I based this on what happens
>> in V4L2 with the S_PRIORITY ioctl.
>>
>> However, I think EACCES is a much better error code. It's probably what S_PRIO should
>> have used as well.
>>
>> Do you agree?
> 
> Not really. EACCES sounds more like a permanent problem, while EBUSY
> is always a temporary issue.
> 
> The problem with EACESS is that the user may think that the file
> permissions at the /dev/cec? are wrong.

Hmm, OK. I'm not entirely convinced, but I don't think it is a big deal either.

Besides, now I don't need to change anything :-)

Regards,

	Hans
