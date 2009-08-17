Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7HDsQ34014422
	for <video4linux-list@redhat.com>; Mon, 17 Aug 2009 09:54:26 -0400
Received: from tomts35-srv.bellnexxia.net (tomts35.bellnexxia.net
	[209.226.175.109])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7HDs6nS024116
	for <video4linux-list@redhat.com>; Mon, 17 Aug 2009 09:54:06 -0400
Received: from toip52-bus.srvr.bell.ca ([67.69.240.55])
	by tomts35-srv.bellnexxia.net
	(InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP id
	<20090817135405.OTN8518.tomts35-srv.bellnexxia.net@toip52-bus.srvr.bell.ca>
	for <video4linux-list@redhat.com>; Mon, 17 Aug 2009 09:54:05 -0400
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Mon, 17 Aug 2009 09:52:28 -0400
Message-ID: <09CD2F1A09A6ED498A24D850EB1012081B1E6D55F8@Colmatec004.COLMATEC.INT>
References: <4A872D3F.6020003@ntnu.no>
	<1250383433.28382.2.camel@localhost.localdomain>
	<20090816080309.3f19a067@tele>
	<4A87C4EC.6030309@ntnu.no>,<20090816110953.1d1074bb@tele>
In-Reply-To: <20090816110953.1d1074bb@tele>
Content-Language: fr-CA
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: RE : Varying frame rate
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

Hi, I want to know what is the new procedure or 

email adress for the new V4L newsletter?
________________________________________
De : video4linux-list-bounces@redhat.com [video4linux-list-bounces@redhat.com] de la part de Jean-Francois Moine [moinejf@free.fr]
Date d'envoi : 16 août 2009 05:09
À : video4linux-list@redhat.com
Objet : Re: Varying frame rate

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
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--

This message has been verified by LastSpam (http://www.lastspam.com) eMail security service, provided by SoluLAN
Ce courriel a ete verifie par le service de securite pour courriels LastSpam (http://www.lastspam.com), fourni par SoluLAN (http://www.solulan.com)
www.solulan.com


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
