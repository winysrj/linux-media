Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:11009 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZELVME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:12:04 -0400
Received: by wf-out-1314.google.com with SMTP id 26so178914wfd.4
        for <linux-media@vger.kernel.org>; Tue, 12 May 2009 14:12:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1BBC94C9-869D-4335-8AB5-6A66CEC6CB1A@gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com>
	 <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com>
	 <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com>
	 <412bdbff0905061410k30d7114dk97cec1cc19c47b2b@mail.gmail.com>
	 <47468C2F-83E4-4359-A1F2-7F59AC6A0E53@gmail.com>
	 <412bdbff0905062055k7cefb714wb496ef48464df99a@mail.gmail.com>
	 <87F5FF15-F869-4FEC-946B-C4D6D0C9506E@gmail.com>
	 <829197380905121356y1d76d73eu4738e3e926c11d27@mail.gmail.com>
	 <1BBC94C9-869D-4335-8AB5-6A66CEC6CB1A@gmail.com>
Date: Tue, 12 May 2009 17:12:05 -0400
Message-ID: <829197380905121412sa81703ekf843b799732481bf@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Britney Fransen <britney.fransen@gmail.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 12, 2009 at 4:59 PM, Britney Fransen
<britney.fransen@gmail.com> wrote:
> Great!  Any chance the QAM64 patch will make it in too?
>
> Britney

The QAM64 support is not related to the xc5000 work, so I won't be
putting it into the same patch series.  However, it is toward the top
of my queue to get that submitted separately once I've had a chance to
review the au8522 registers being programmed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
