Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0BJVvad023685
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 14:31:57 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0BJVeHC008719
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 14:31:41 -0500
Date: Sun, 11 Jan 2009 20:25:04 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Stas Sergeev <stsp@aknet.ru>
Message-ID: <20090111202504.644c2bb0@free.fr>
In-Reply-To: <4968EE9A.5040901@aknet.ru>
References: <4968EE9A.5040901@aknet.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [patch] add video_nr module param to gspca
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

On Sat, 10 Jan 2009 21:53:14 +0300
Stas Sergeev <stsp@aknet.ru> wrote:

> Hi.
> 
> The attached patch adds the
> module_param for video_nr to
> the gspca driver.
> The patch is completely untested
> as I don't use any webcam myself.
> Its just that a friend of mine
> complained about an inability to
> set the device number for gspca
> and I hope this patch can solve
> that problem.

Hi,

I don't think such a patch is usefull.

Instead, as every system runs udev, it is simpler to add a rule as:

  ATTRS{idVendor}=="05e1",ATTRS{idProduct}=="0893",NAME="video3"

Best regards.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
