Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2-vm0.bullet.mail.ird.yahoo.com ([77.238.189.199]:45816 "HELO
	nm2-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756643Ab2DFMMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 08:12:03 -0400
Message-ID: <4F7EDC31.4010001@btinternet.com>
Date: Fri, 06 Apr 2012 13:06:09 +0100
From: Chris Rankin <rankincj@btinternet.com>
MIME-Version: 1.0
To: crope@iki.fi
CC: linux-media@vger.kernel.org
Subject: Re: DVB ioctl FE_GET_EVENT behaviour broken in 3.3
References: <4F7ED7E9.203@iki.fi>
In-Reply-To: <4F7ED7E9.203@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 > Before LOCK you cannot know many parameters at all and frequency also
 > can be changed a little bit during tuning process (ZigZag tuning algo).

But surely the point of calling poll() on the front end's descriptor is either 
to be notified once the tuning algorithm has locked, or to be told that LOCK has 
failed? This would certainly seem to have been xine's assumption for the past 
10+ years.

 > Could you try to git bisect to find out patch causing that regression?

I don't have a git tree to bisect with, so I expect I'll have to resort to more 
"old fashioned" methods.

 > I suspect it is some change done for DVB core

Me too, because this bug is affecting *every* DVB adapter that I own. (All USB, 
but anyway...)

Cheers,
Chris
