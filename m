Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47798 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZJWQp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 12:45:28 -0400
Received: by ewy4 with SMTP id 4so1807846ewy.37
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 09:45:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091023174705.7db4db52@hyperion.delvare>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <20091023174705.7db4db52@hyperion.delvare>
Date: Fri, 23 Oct 2009 12:45:31 -0400
Message-ID: <37219a840910230945l4d52bd6dj33e33adf440d33ef@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Michael Krufky <mkrufky@kernellabs.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 23, 2009 at 11:47 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Thu, 22 Oct 2009 21:13:30 +0200, Jean Delvare wrote:
>> For example, the signal strength. All I know so far is that this is a
>> 16-bit value. But then what? Do greater values represent stronger
>> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
>> returned value meaningful even when FE_HAS_SIGNAL is 0? When
>> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
>> well-defined meanings, or is it arbitrary and each driver can have its
>> own scale? What are the typical use cases by user-space application for
>> this value?
>
> To close the chapter on signal strength... I understand now that we
> don't have strict rules about the exact values. But do we have at least
> a common agreement that greater values mean stronger signal? I am
> asking because the DVB-T adapter model I have here behaves very
> strangely in this respect. I get values of:
> * 0xffff when there's no signal at all
> * 0x2828 to 0x2e2e when signal is OK
> * greater values as signal weakens (I have an amplified antenna with
>  manual gain control) up to 0x7272
>
> I would have expected it the other way around: 0x0000 for no signal and
> greater values as signal strengthens. I think the frontend driver
> (cx22702) needs to be fixed.
>
> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



I have a solution for this across the entire DVB subsystem, but I
haven't had time to write up a formal explanation.

I will follow up with better info when I have time.

Regards,

Mike Krufky
