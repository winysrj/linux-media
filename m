Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6TFL8Px021695
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 11:21:08 -0400
Received: from mail-yx0-f194.google.com (mail-yx0-f194.google.com
	[209.85.210.194])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6TFKo2N022352
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 11:20:50 -0400
Received: by yxe32 with SMTP id 32so3443037yxe.6
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 08:20:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A706591.2090707@gmail.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<1246654555282-3203325.post@n2.nabble.com>
	<1246882966.1165.1323684945@webmail.messagingengine.com>
	<4A7058FA.4060409@gmail.com>
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
	<829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
	<4A706591.2090707@gmail.com>
Date: Wed, 29 Jul 2009 11:20:50 -0400
Message-ID: <829197380907290820j2ed4d4a0ycdccf8ffebd992ca@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "buhochileno@gmail.com" <buhochileno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: V4L Mailing List <video4linux-list@redhat.com>
Subject: Re: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera -
	No Composite Input
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

On Wed, Jul 29, 2009 at 11:06 AM,
buhochileno@gmail.com<buhochileno@gmail.com> wrote:
> weird, I follow the exact instruction of the previous mail, also doing a
> update at the v4l-dvb there is no update:
> shell> hg update
> 0 files updated, 0 files merged, 0 files removed, 0 files unresolved

Ah, you must be a cvs or svn user.  With hg, running "hg update" from
your working directory doesn't actually go to the server to download
the latest code.  To update to the latest code, you would need to run:

cd v4l-dvb
hg pull http://linuxtv.org/hg/v4l-dvb
hg update

That said, I would suggest you just do a fresh clone and try again.
If you want, you can send me the full output as an attachment
off-list, and I can take a look and see if there are any obvious
problems.

>> Also, rereading your email, are you sure the device has a tuner?  Do
>> you know what tuner chip it contains?  If not, can you send digital
>> photos of the PCB?
>>
>
> Yeap, it have a turner becouse it is the robotis bioloid wireless camera
> set, that have this receiver recognized as the PointNix... witch use
> channels, 1, 2, 3. 4 to get the image wirelessly from the camera, no idea
> about what turner chip it use, going to see if I can take some photos of the
> PCB, but it is still with warrantie so I a little concern about it...

Can you send me a link to the webpage for the product?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
