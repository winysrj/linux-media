Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1HPK6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 06:58:30 -0400
Received: by bke11 with SMTP id 11so3619670bke.19
        for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 03:58:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <p06240803ca6f0fc5adb0@simon.thehobsons.co.uk>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
	<1313226504.2840.22.camel@gagarin>
	<p06240803ca6f0fc5adb0@simon.thehobsons.co.uk>
Date: Tue, 16 Aug 2011 12:58:29 +0200
Message-ID: <CAC3jWvJFnMBp+xxQEN-xHYHpvrHcG3D4W4PHDM26f-7YPby1Dw@mail.gmail.com>
Subject: Re: [mythtv-users] Anyone tested the DVB-T2 dual tuner TBS6280?
From: Harald Gustafsson <hgu1972@gmail.com>
To: Discussion about MythTV <mythtv-users@mythtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 15, 2011 at 8:11 PM, Simon Hobson <linux@thehobsons.co.uk> wrote:
>>Date: Sat, 13 Aug 2011 22:08:30 +0300
>>From: Turbosight Europe <euro_support@tbsdtv.com>
...
>>also, in case of TBS 6280 there is something else you should know -
>>currently we keep two separate Linux drivers: one that support DVB-T
>>only and another that supports DVB-T2 only. that's because we want
>>more people to test those two drivers before we merge them and it's
>>more efficient to locate the problem in case a customer report such.
>>so, the driver for TBS 6280 you can find on our website supports
>>DVB-T only, but it can be switched to support DVB-T2 very easy. so,
>>single driver that supports DVB-T and DVB-T2 will be released after
>>we're sure both codes are bug-free. so, far feedback we received
>>doesn't reveal any serious bugs and reported problems were fixed -
>>as i mentioned we already have customers in UK that are Linux users
>>and use the card to watch DVB-T2 signal in UK.

OK so this states that the current drivers don't support both DVB-T
and -T2 simultaneously. This is good to know since this would be my
common usage, going to record DVB-T2 on one of the tuners while
recording DVB-T on the other.

/Harald
