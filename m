Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77ARjw6015194
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 06:27:46 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77ARYbN019897
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 06:27:34 -0400
Message-ID: <489AD045.7030404@hhs.nl>
Date: Thu, 07 Aug 2008 12:36:53 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: RFC: adding a flag to indicate a webcam sensor is installed upside
 down
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

I have this Philips SPC 200NC webcam, which has its sensor installed upside 
down and the sensor does not seem to support flipping the image. So I believe 
the windows drivers fix this little problem in software.

I would like to add a flag somewhere to indicate this to userspace (and then 
add flipping code to libv4l).

I think the best place for this would the flags field of the v4l2_fmtdesc 
struct. Any other ideas / objections to this?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
