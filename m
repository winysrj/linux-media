Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab0BDOHz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 09:07:55 -0500
Message-ID: <4B6C24FF.4050802@redhat.com>
Date: Fri, 05 Feb 2010 09:02:39 -0500
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
	Antti Palosaari <crope@iki.fi>, mchehab@infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Pekka Sarnila <sarnila@adit.fi>, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6AB7E9.40607@redhat.com> <4B6AC333.6030308@gmail.com> <4B6ACEA3.3080900@redhat.com>
In-Reply-To: <4B6ACEA3.3080900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2010 08:41 AM, Mauro Carvalho Chehab wrote:
> Jiri Slaby wrote:
>> On 02/04/2010 01:04 PM, Mauro Carvalho Chehab wrote:
>>>> I have 2 dvb-t receivers and both of them need fullspeed quirk. Further
>>>> disable_rc_polling (a dvb_usb module parameter) must be set to not get
>>>> doubled characters now. And then, it works like a charm.
>>> Module parameters always bothers me. They should be used as last resort alternatives
>>> when there's no other possible way to make it work properly.
>>>
>>> If we know for sure that the RC polling should be disabled by an specific device,
>>> just add this logic at the driver.
>>
>> Yes, this is planned and written below:
>
> Ok.
>>
>>>> Note that, it's just some kind of proof of concept. A migration of
>>>> af9015 devices from dvb-usb-remote needs to be done first.
>>>>
>>>> Ideas, comments?
>>> Please next time, send the patch inlined. As you're using Thunderbird, you'll likely need
>>> Asalted-patches[1] to avoid thunderbird to destroy your patches.
>>
>> I must disagree for two reasons: (a) it was not patch intended for merge
>> and (b) it was a plain-text attachment which is fine even for
>> submission. However I don't like patches as attachments so if I decide
>> to submit it for a merge later, you will not see it as an attachment
>> then :).
>
> Attachments aren't good for reply, as they appear as a file. So, people need to
> open the attachment on a separate application to see and to cut-and-paste
> if they want to comment, like what I did.

Just as an FYI... If you use mutt appropriately configured, it'll DTRT 
with attached patches and let you reply with them quoted inline, and 
actually, thunderbird 3 will more or less work with attached patches if 
you do a select-all, then hit reply (tbird finally has 'quote selected 
text' support).

Not that I'm advocating patches as attachments.

-- 
Jarod Wilson
jarod@redhat.com
