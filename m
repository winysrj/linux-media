Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ANFB1D002517
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 19:15:11 -0400
Received: from n28.bullet.mail.ukl.yahoo.com (n28.bullet.mail.ukl.yahoo.com
	[87.248.110.145])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6ANEvMd031344
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 19:14:58 -0400
Date: Thu, 10 Jul 2008 23:14:51 +0000 (GMT)
From: Malsoaz James <jmalsoaz@yahoo.fr>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <122708.39761.qm@web28403.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re : Own software to use a camera
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

Thank you for your help, I will have a look at that.=0A=0AHave you any docu=
ment about the function present in this library ? I mean information on the=
 arguments used in each function, list of the functions and their goal, ...=
=0A=0AFor example, for v4l2_open, there is a char * =3D /dev/video0 and the=
n a flag certainly O_RDWR, ...=0A=0A=0A----- Message d'origine ----=0ADe : =
Thierry Merle <thierry.merle@free.fr>=0A=C3=80 : David Ellingsworth <david@=
identd.dyndns.org>=0ACc : Malsoaz James <jmalsoaz@yahoo.fr>; video4linux-li=
st@redhat.com=0AEnvoy=C3=A9 le : Jeudi, 10 Juillet 2008, 12h08mn 14s=0AObje=
t : Re: Own software to use a camera=0A=0ADavid Ellingsworth a =C3=A9crit :=
=0A> James,=0A>=0A> I suspect you may benefit from using the new v4l-librar=
y. It should=0A> help simplify the conversion of whatever format the camera=
 supports=0A> into whichever format your application desires. The current=
=0A> development branch of the library is located here:=0A> http://linuxtv.=
org/hg/~tmerle/v4l2-library/=0A>=0A> Regards,=0A>=0A> David Ellingsworth=0A=
>  =0AAnd now this library is integrated in the current v4l-dvb branch=0Aht=
tp://linuxtv.org/hg/v4l-dvb=0AYou will find the lib in v4l2-apps/lib/libv4l=
..=0AAll this work was made by Hans de Goede.=0A=0ACheers,=0AThierry=0A=0A=
=0A=0A      _______________________________________________________________=
______________ =0AEnvoyez avec Yahoo! Mail. Une boite mail plus intelligent=
e http://mail.yahoo.fr
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
