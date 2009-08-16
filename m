Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7G9ADi2013246
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 05:10:13 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7G99v8l012192
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 05:09:58 -0400
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id DB3538180D7
	for <video4linux-list@redhat.com>;
	Sun, 16 Aug 2009 11:09:55 +0200 (CEST)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id DAF7581812A
	for <video4linux-list@redhat.com>;
	Sun, 16 Aug 2009 11:09:52 +0200 (CEST)
Date: Sun, 16 Aug 2009 11:09:53 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
Message-ID: <20090816110953.1d1074bb@tele>
In-Reply-To: <4A87C4EC.6030309@ntnu.no>
References: <4A872D3F.6020003@ntnu.no>
	<1250383433.28382.2.camel@localhost.localdomain>
	<20090816080309.3f19a067@tele> <4A87C4EC.6030309@ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: Varying frame rate
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

On Sun, 16 Aug 2009 10:35:56 +0200
Haavard Holm <haavard.holm@ntnu.no> wrote:
	[snip]
> > The frame rate depends on the exposure time. If auto exposure is
> > set, you may have such a behaviour.
> >    
> 
>  From a c-program - how do I turn off auto exposure ?

You may do it by the VIDIOC_S_CTRL ioctl (look at
v4l2-apps/util/v4l2-ctl.cpp in the LinuxTv mercurial main repository)

Otherwise, by program, I know about v4l2ucp or vlc (1.0.x).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
