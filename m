Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60446 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZHTWQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 18:16:41 -0400
Received: by ewy3 with SMTP id 3so248681ewy.18
        for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 15:16:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8C076C.8040109@deuromedia.com>
References: <4A8C076C.8040109@deuromedia.com>
Date: Thu, 20 Aug 2009 18:16:41 -0400
Message-ID: <37219a840908201516p23f5164fs98ad7f8267362d85@mail.gmail.com>
Subject: Re: V4L-DVB issue in systems with >4Gb RAM?
From: Michael Krufky <mkrufky@kernellabs.com>
To: h.ungar@deuromedia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manfred Petz <m.petz@deuromedia.com>,
	Gerhard Achs <g.achs@deuromedia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 19, 2009 at 10:08 AM, Helmut Ungar<h.ungar@deuromedia.com> wrote:
>
> Hi,
>
> we are experiencing a problem with the V4L-DVB drivers.
> It seems that when the system has over 4Gb the drivers
> do no longer work properly. Either nothing or rubbish comes out of them,
> although tuning using szap seems to
> work. If we force the system to use only 4Gb by appending
> mem=4GB as a kernel parameter things are working like a
> charm.
>
> Our setup:
> Dell 2850 server with a Magma PCI extender. There are 6 DVB boards in the
> machine: 5 KNC TV STAR DVB-S and 1 Hauppauge Nova-S-Plus DVB-S.
> The system has 8GB of RAM and runs an up-to-date Centos5.3, kernel
> 2.6.18-128.4.1.el5 x86_64. The V4L-DVB driver we are using is
> v4l-dvb-2009.08.18.tar.bz2
> On this setup some of the KNC boards are working, the Hauppauge
> does not. In a similar setup where we have only KNCs none
> of them is working unless you force the system to use 4Gb of the available
> memory.
>
> I would like to know if this is a known issue and if so
> what can be done to fix/work around the problem.
>
> Any help/suggestion/hint is highly welcome.
> Thanks in advance!
> Kind regards,
> Helmut

I have a server with three cx23885-based PCI-E boards, one of them
single tuner, the other two with dual tuners.  This server has 8G RAM.
 The single tuner is a Hauppauge board and the dual tuners are DViCO
boards.  (I chose this setup for maximum tuner capacity and brand
diversity for the sake of testing -- I plan to replace the DViCO
boards with two HVR2250's)

So, in summary, my 8G system has five digital tuners and I am not
experiencing the problems that you report.  I doubt the issue is
within the v4l-dvb subsystem.

Good luck,

Mike Krufky
