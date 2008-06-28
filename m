Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SHKYa5020288
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 13:20:34 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SHKM0m022995
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 13:20:23 -0400
Date: Sat, 28 Jun 2008 19:20:15 +0200
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080628172015.GG18818@vidsoft.de>
References: <48660D68.8040506@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48660D68.8040506@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: Announcing libv4l 0.2
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

Hi,

On Sat, Jun 28, 2008 at 12:07:36PM +0200, Hans de Goede wrote:
> libv4l-0.2
> ----------
> *** API change ***

It would be usesul if you expose the library or api version in your
public header files like for example OpenSSL in <openssl/opensslv.h>.
So the develpers can keep their code backward compatible with some
simple ifdefs.

Thanks,
Gregor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
