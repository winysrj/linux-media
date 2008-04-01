Return-path: <video4linux-list-bounces@redhat.com>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Tue, 1 Apr 2008 13:31:50 +1100
Message-ID: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1F@SRV-QS-MAIL5.lands.nsw>
From: "Nicholas Magers" <Nicholas.Magers@lands.nsw.gov.au>
To: "Ben Caldwell" <benny.caldwell@gmail.com>, <video4linux-list@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: alan@redhat.com
Subject: RE: Dvico Dual 4 card not working.
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

I'll be interested in the result.=0D=0A=0D=0A =0D=0A=0D=0AFrom: Ben Caldwell=
 [mailto:benny.caldwell@gmail.com] =0D=0ASent: Tuesday, 1 April 2008 12:54 P=
M=0D=0ATo: video4linux-list@redhat.com=0D=0ACc: alan@redhat.com; Nicholas Ma=
gers=0D=0ASubject: Re: Dvico Dual 4 card not working.=0D=0A=0D=0A =0D=0A=0D=0A=
	---------- Forwarded message ----------=0D=0A	From: Alan Cox <alan@redhat.c=
om>=0D=0A	To: Nicholas Magers <Nicholas.Magers@lands.nsw.gov.au>=0D=0A	Date:=
 Mon, 31 Mar 2008 05:32:05 -0400=0D=0A	Subject: Re: Dvico Dual 4 card not wo=
rking.=0D=0A	On Mon, Mar 31, 2008 at 02:22:15PM +1100, Nicholas Magers wrote=
:=0D=0A	> Dual 4 card no longer works. I use it with Mythtv. It seems=0D=0Aw=
hen I=0D=0A	> updated my Nvidia graphics driver from Livna it had an effect=
.=0D=0AI am at=0D=0A	=0D=0A	Nvidia driver reports should go to Nvidia, only =
they have the=0D=0Asource code=0D=0A	so only they can help you=0D=0A=0D=0AI =
have recently posted a similar problem with the dvico dual digital 4=0D=0Aca=
rd on a Fedora 8 mythtv box. I don't think that this problem is due t=
o=0D=0Athe nvidia driver.=0D=0A=0D=0AMy tuner card was working fine until I =
updated the to the latest v4l=0D=0Asource from the hg repository a week or t=
wo back and made new kernel=0D=0Amodules, I included traces in my post which=
 can be seen in the list=0D=0Aarchives at the end of march.=0D=0A=0D=0AI rev=
erted to a previous kernel that still has the kernel modules made=0D=0Afrom =
an earlier version of the v4l source and everything works fine=0D=0Aagain. I=
 am not going to try compiling new modules for the working=0D=0Akernel as it=
 could leave me with no way at all to use my tuner card.=0D=0A=0D=0A =0D=0A=0D=0A=
So tonight I will try building modules for my latest kernel (from Fedor=
a=0D=0Aupdates) from an older version of the v4l source and report back to t=
his=0D=0Alist with the results.=0D=0A=0D=0A =0D=0A=0D=0A- Ben Caldwel=
l=0D=0A=0D=0A=0D=0A*********************************************************=
******=0D=0AThis message is intended for the addressee named and may contain=
 confidential information. If you are not the intended recipient, please del=
ete it and notify the sender. =0D=0A=0D=0AViews expressed in this message ar=
e those of the individual sender, and are not necessarily the views of the D=
epartment of  Lands.=0D=0A=0D=0AThis email message has been swept by MIMEswe=
eper for the presence of computer viruses.=0D=0A****************************=
***********************************=0D=0A
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
