Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n09FEMZH030082
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 10:14:22 -0500
Received: from web95205.mail.in2.yahoo.com (web95205.mail.in2.yahoo.com
	[203.104.18.181])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n09FDKI0032305
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 10:13:21 -0500
Date: Fri, 9 Jan 2009 20:43:19 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: Jeyner Gil Caga <jeynergilcaga@gmail.com>,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <cad107560901082138q3636b349y12d10ad898caa7d6@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <761985.47529.qm@web95205.mail.in2.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Re: About xawtv
Reply-To: shariefbe@yahoo.co.in
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


yes i too think that...but in streamer program no mmap() function...then ho=
w it will store the data in buffer?Thats my main problem....can you clear m=
y doubt....
--- On Fri, 9/1/09, Jeyner Gil Caga <jeynergilcaga@gmail.com> wrote:
From: Jeyner Gil Caga <jeynergilcaga@gmail.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in, "video4linux list" <video4linux-list@redhat.com>
Date: Friday, 9 January, 2009, 11:08 AM

Xawtv package contains streamer application. Please look for streamer.c ins=
ide console directory. For sample usage of streamer application, try stream=
er --help.

On Thu, Jan 8, 2009 at 1:31 AM, niamathullah sharief <shariefbe@yahoo.co.in=
> wrote:

Hello friends,



=C2=A0 =C2=A0i downloaded the xawtv package...but i dont which program is u=
sed to capture the video....i found there is a program called "capture.c" i=
n common directory in that package..but i didnt find any memory mapping fun=
ction in that program....so i am very much confused......can anyone tell me=
 which program is used to capture the image....?Thanks a lot...










 =C2=A0 =C2=A0 =C2=A0Connect with friends all over the world. Get Yahoo! In=
dia Messenger at http://in.messenger.yahoo.com/?wm=3Dn/

--

video4linux-list mailing list

Unsubscribe mailto:video4linux-list-request@redhat.com?subjectunsubscribe

https://www.redhat.com/mailman/listinfo/video4linux-list



=0A=0A=0A      Get perfect Email ID for your Resume. Grab now http://in.pro=
mos.yahoo.com/address
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
