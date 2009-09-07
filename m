Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.211.175]:44632 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZIGRhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 13:37:22 -0400
Received: by ywh5 with SMTP id 5so3739929ywh.4
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 10:37:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37219a840909070952j19148dabwa47439ef91f5fb99@mail.gmail.com>
References: <957e58a90909070935i5b74559cl34e18c5fac835f2d@mail.gmail.com>
	 <37219a840909070952j19148dabwa47439ef91f5fb99@mail.gmail.com>
Date: Mon, 7 Sep 2009 19:37:25 +0200
Message-ID: <175f5a0f0909071037q38659691q1e2da8845bbfaf0@mail.gmail.com>
Subject: Re: ML delivery failures
From: "H. Willstrand" <h.willstrand@gmail.com>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Randy Dunlap <randy.dunlap@gmail.com>,
	Steven Toth <stoth@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 7, 2009 at 6:52 PM, Michael Krufky<mkrufky@kernellabs.com> wrote:
> On Mon, Sep 7, 2009 at 12:35 PM, Randy Dunlap<randy.dunlap@gmail.com> wrote:
>> On Mon, 07 Sep 2009 09:20:02 -0400 Steven Toth wrote:
>>
>>> Hi,
>>>
>>> I have the traffic from this list going to a gmail account. I normally use
>>> thunderbird to respond to emails and never have issues posting to the ML.
>>>
>>> If I'm away from thunderbird and try to respond via the google apps gmail
>>> interface my mails always get bounced from vger's mail daemon, claiming that the
>>> message has a html sub-part, and is considered spam or an outlook virus - thus
>>> rejected.
>>>
>>> It's happened a few times, again today when responding to Simon's comment about
>>> the relationship between the 716x and the 7162 driver.
>>>
>>> I don't see any obvious 'use-non-html' formatting setting in gmail.
>>
>> In a compose window, just below "Attach a file", click on
>> "Plain text".  [testing:  sent from gmail like that]
>>
>>> Perhaps someone else has seen this issue or knows of a workaround?
>>>
>>> Comments / feedback appreciated.
>>
>>
>> ---
>> ~Randy
>> LPC 2009, Sept. 23-25, Portland, Oregon
>> http://linuxplumbersconf.org/2009/
>
> At this point, I use *only* gmail to respond to mailing list posts.
>
> Steve, I have the same problem that you are complaining about when I
> use the kernellabs / gmail interface.  It's probably some issue with
> google labs.  My regular gmail account works fine -- I just change the
> reply-to to my kernellabs email account.
>
> -Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

In gmail, go to settings, choose tab General, and click on: "Use
default text encoding for outgoing messages"

//HW
