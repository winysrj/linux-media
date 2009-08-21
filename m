Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx06.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7L8dn1M006967
	for <video4linux-list@redhat.com>; Fri, 21 Aug 2009 04:39:49 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7L8dUV2029196
	for <video4linux-list@redhat.com>; Fri, 21 Aug 2009 04:39:35 -0400
Date: Fri, 21 Aug 2009 10:39:25 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: "Nilo Roberto C Paim" <nilopaim@gmail.com>
Message-ID: <20090821103925.038c98ce@tele>
In-Reply-To: <004a01ca21b6$e3cabe80$ab603b80$@com>
References: <004a01ca21b6$e3cabe80$ab603b80$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: How to detect USB camera disconnection?
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

On Thu, 20 Aug 2009 13:54:26 -0300
"Nilo Roberto C Paim" <nilopaim@gmail.com> wrote:

> I've a Vimicro USB cam that I'm constantly pooling for taking
> snapshots using an application made by me. How can I programmatically
> detect when the cam is disconnected?
> 
> It seems to me that V4L "thinks" that the cam is still there, even
> with the cable disconnected.
> 
> --- >  I'd forgot to say: the driver I'm using is gspca, last
> version. Works like a charm. My problem is related to cable's cam
> disconnected.

Hi Nilo,

I don't know how you poll. Normally, when the webcam is disconnected,
the I/O calls should fail with errno = NODEV.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
