Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAM4IgL5021152
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 23:18:42 -0500
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAM4IRoV012935
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 23:18:27 -0500
Received: by ik-out-1112.google.com with SMTP id c21so1035491ika.3
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 20:18:26 -0800 (PST)
Message-ID: <412bdbff0811212018ycee33f9obdd171bda2a77ff7@mail.gmail.com>
Date: Fri, 21 Nov 2008 23:18:26 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Ben Klein" <shacklein@gmail.com>
In-Reply-To: <d7e40be30811211649s79047226ne2f79a4dced9c7c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
	<d7e40be30811211600u354bf1ebg57567ebd3cd375a@mail.gmail.com>
	<412bdbff0811211615r4ed250f8q12b28eda3a352778@mail.gmail.com>
	<d7e40be30811211649s79047226ne2f79a4dced9c7c7@mail.gmail.com>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [video4linux] Attention em28xx users
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

On Fri, Nov 21, 2008 at 7:49 PM, Ben Klein <shacklein@gmail.com> wrote:
> 2008/11/22 Devin Heitmueller <devin.heitmueller@gmail.com>:
> I don't think it'd be easy if possible at all to find technical
> details about it, but this is the device:
> http://www.unisupport.net/lang/au/dvd-grabber.htm
>
> Audio is usb-audio, inputs are S-Video and Composite. No TV tuner (or
> at least nowhere to stick an antenna) and no remote control.
>
> Thanks for your help :) If you need more information (like lsusb
> output), just let me know

That, combined with the dmesg output you sent previously, should be
enough for me to add a device profile.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
