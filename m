Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJC0VTp009144
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 07:00:31 -0500
Received: from web32104.mail.mud.yahoo.com (web32104.mail.mud.yahoo.com
	[68.142.207.118])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBJBwlcR013344
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 06:58:47 -0500
Date: Fri, 19 Dec 2008 03:58:46 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <20081218170015.10DD88E03CC@hormel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <44440.83878.qm@web32104.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: soc-camera: current stack
Reply-To: gatoguan-os@yahoo.com
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Guennadi, 

On Tue, 18/12/08, Guennadi Liakhovetski wrote:
> ... My current stack is at
> 
> http://gross-embedded.homelinux.org/~lyakh/v4l-20081217/
> ...

I was about to try this stack on my Phytec i.MX31 system when I found there is no mx3_camera driver in it. Too bad!

I still haven't been able to retrieve a VGA sized dummy image from my FPGA on a Phytec dev-kit, stuck at "select timeout". I was hoping that this new stack could have some important stuff that your previous (from November) didn't.

I can't tell if I am having a hardware issue... Do you have any modification or fix in your Phytec i.MX31 dev-kit?

Thanks & regards,
--Agustín.

--
Agustin Ferrin Pozuelo
Embedded Systems Consultant
http://embedded.ferrin.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
