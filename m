Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <412bdbff0901032118y9dda1c2uaeb451c0874a65cd@mail.gmail.com>
Date: Sun, 4 Jan 2009 00:18:56 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Robert Krakora" <rob.krakora@messagenetsystems.com>
In-Reply-To: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>
Cc: Jerry Geis <geisj@messagenetsystems.com>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: KWorld 330U Employs Samsung S5H1409X01 Demodulator
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

On Sat, Jan 3, 2009 at 11:21 PM, Robert Krakora
<rob.krakora@messagenetsystems.com> wrote:
> Mauro:
>
> The KWorld 330U employs the Samsung S5H1409X01 demodulator, not the
> LGDT330X.  Hence the error initializing the LGDT330X in the current source
> in em28xx-dvb.c.
>
> Best Regards,

Hello Robert,

Well, that's good to know.  I don't think anyone has done any work on
that device recently, so I don't know why the code has it as an
lgdt3303.

Do you know which tuner chip the device has?  The reason I ask is
because I'm working on another device that also has the s5h1409, and
it's got an xc3028L (the low power version of the xc3028).  If the
330U also has the xc3028L, then we need to make sure to indicate that
in the device profile so it doesn't burn out the chip.

We're probably also going to need to get a Windows trace, so we know
how to setup the s5h1409 configuration.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
