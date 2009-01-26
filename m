Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:36504 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZAZBgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 20:36:36 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2722085qwe.37
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2009 17:36:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497CE87A.3090605@rogers.com>
References: <20090123015815.GA22113@shibaya.lonestar.org>
	 <497CB355.3030408@rogers.com>
	 <20090125214637.GA11948@shibaya.lonestar.org>
	 <497CE87A.3090605@rogers.com>
Date: Sun, 25 Jan 2009 20:36:35 -0500
Message-ID: <412bdbff0901251736u55426d66tbbba806a13048cde@mail.gmail.com>
Subject: Re: [linux-dvb] Tuning a pvrusb2 device. Every attempt has failed.
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: CityK <cityk@rogers.com>
Cc: "A. F. Cano" <afc@shibaya.lonestar.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 25, 2009 at 5:32 PM, CityK <cityk@rogers.com> wrote:
> I haven't taken the opportunity to ever use Kaffeine for scanning OTA
> just yet, however, I do note that it produces similar results for me, as
> to what you observed, when I scan on digital cable using QAM256. In my
> case, it repeatedly borks at 61%. I spoke with Mkrufky this morning
> about Kaffeine's ATSC scanning abilities and he described it as being
> less then favourable....this was actually a surprise to me, as I thought
> that OTA scanning was fine. I know Devin added this support so perhaps
> he could comment upon the capabilities. I also know that Devin does not
> have cable, so I am not surprised to see, in my case, scans of digital
> cable failing.

Yeah, digital cable scanning is pretty much known to be broken in
Kaffeine.  None of the cable companies followed the recommendations in
the ATSC a/63c standard since they rely on the OOB tuner to get
channel information.  I have some hacks that work around some of the
issues, but none of them are upstream yet.  As CityK pointed out, I do
not have cable, so I have done very little testing in that
environment.

Regarding OTA, there are no outstanding bugs so it should be fine.
There is *one* known issue which was fixed after 0.8.7 went out, but
if you hit the issue (a timing bug), Kaffeine will crash.  In other
words, if you are just getting no channels found, then it's not that
case.

If you do have a case where OTA scanning in Kaffeine returns different
results than w_scan or scan, I would be interested in hearing about
it.  Send me some email off-list and I will see if we can work through
the issue.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
