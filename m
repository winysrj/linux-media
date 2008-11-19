Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJL5W2p001033
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 16:05:32 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJL5IYk006846
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 16:05:19 -0500
Received: by nf-out-0910.google.com with SMTP id d3so78746nfc.21
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 13:05:18 -0800 (PST)
Message-ID: <412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
Date: Wed, 19 Nov 2008 16:05:18 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
In-Reply-To: <alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
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

On Wed, Nov 19, 2008 at 3:38 PM, Kiss Gabor (Bitman)
<kissg@ssg.ki.iif.hu> wrote:
> Unfortunately I cannot do this.
> I have no Windows machine.
>
> Some month ago we tried to install Windows drivers on my brother's
> XP but we were unsuccesful.
>
>
> Yesterday I tried to load em28xx module with different card numbers
> and two or three times I had nice picture. With card=3 and card=7.
> However after a few tests it seems to be crashed and since then it
> does not work any more.
>
> Gabor

Hello Gabor,

Playing with the "card=" argument is probably not such a good idea.
I should consider taking that functionality out, since setting to the
wrong card number can damage the device (by setting the wrong GPIOs).

If somebody can get me a USB trace of the device starting up under
Windows, I can probably make this card work.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
