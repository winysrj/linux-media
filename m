Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab3AQWqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 17:46:44 -0500
Date: Thu, 17 Jan 2013 20:46:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130117204601.7306bb91@redhat.com>
In-Reply-To: <50F87988.5060605@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
	<20130117145036.55745a60@redhat.com>
	<50F831AA.8010708@iki.fi>
	<20130117161126.6b2e809d@redhat.com>
	<50F84276.3080909@iki.fi>
	<CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com>
	<20130117165037.6ed80366@redhat.com>
	<50F84CCC.5040103@iki.fi>
	<CAHFNz9LzWG4DX6s0FieNoiae=A3a=h+JzXAG1XPTMvANb93Skg@mail.gmail.com>
	<50F87988.5060605@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Jan 2013 00:22:00 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> My propose was to ask if we could add some generic calculations for the 
> DVB-core, so that implementing only one method for the driver is enough. 
> If app is asking relative value and driver does dB, then DVB-core makes 
> conversion. For CNR, take CNR dB and modulation, return relative value 
> for app. For SS conversion is even simpler.

Doing such conversion in kernelspace is simple, but doing it on
userspace is even simpler, as userspace can easily use float point
for the math.

Besides that, as Simon pointed, each application developer may use
different criteria to classify the reception as "poor", "good" and
"excellent".

So, IMHO, the kernel should report the measures on the best way that it is
possible for that hardware, and let userspace to apply the policies to
convert those measures into an user-friendly[1] information.

Regards,
Mauro

[1] Eventually, developers may be wrong about what users expect. By
putting that "quality" policy on userspace, it is easier to adapt it
to the users expectation for that particular application.

For example, I heard a lot of complaints with regards to Gnome 3 shell
because it removed several features that people were present on Gnome 2.
At the end, people  started to write Gnome3 applets in order to re-add
those removed features on Gnome 3, and/or make it look more like Gnome 2.
