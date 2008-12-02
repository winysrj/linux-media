Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB25KD7c026207
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 00:20:13 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB25K2Nj031876
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 00:20:02 -0500
Received: by rv-out-0506.google.com with SMTP id f6so3146555rvb.51
	for <video4linux-list@redhat.com>; Mon, 01 Dec 2008 21:20:01 -0800 (PST)
Message-ID: <78877a450812012120x23aa21a3udd4653aabe0b6b8d@mail.gmail.com>
Date: Tue, 2 Dec 2008 16:20:01 +1100
From: "Gilles GIGAN" <gilles.gigan@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Listing existing video devices
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

Hi all,
I need to enumerate all currently connected V4L devices. So far, I came up
with this:
- First, check with HAL and create a list of objects with the 'video4linux'
capability
- Second, append to the list all char device files with major number 81
- Third, remove the duplicates.

Some (very old) USB cameras (Logitech Quickcam Express for instance) are not
reported by HAL as video devices. Therefore limiting the enumeration to
video devices reported by HAL would not be complete. That s why I added the
second step (listing all char major 81)

Is there a better way of doing this ?

Cheers,
Gilles
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
