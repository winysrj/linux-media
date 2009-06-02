Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n52M4InL008159
	for <video4linux-list@redhat.com>; Tue, 2 Jun 2009 18:04:18 -0400
Received: from relay-pt2.poste.it (relay-pt2.poste.it [62.241.5.253])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n52M420X022857
	for <video4linux-list@redhat.com>; Tue, 2 Jun 2009 18:04:02 -0400
Received: from geppetto.reilabs.com (78.15.188.69) by relay-pt2.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 4A245DBE00008626 for video4linux-list@redhat.com;
	Wed, 3 Jun 2009 00:04:01 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1MBc41-0006Mk-Qe
	for video4linux-list@redhat.com; Wed, 03 Jun 2009 00:02:33 +0200
Date: Wed, 3 Jun 2009 00:02:33 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: video4linux-list Mailing List <video4linux-list@redhat.com>
Message-ID: <20090602220233.GA23136@geppetto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: video loopback device
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

I'm looking for an application/driver which let to create a 
virtual device where to send the video output of an application or of
another video device.

Typical application would be for example to capture from a webcam,
apply some filter to it, and finally pulish it to another application
reading from a video device.

I see there are at least three distinct projects which provides a
video for loopback device:

* video4linux loopback device/vloopback:
  http://www.lavrsen.dk/twiki/bin/view/Motion/VideoFourLinuxLoopbackDevice

  Seems to be unmaintained, also if I'm not wrong it only supports
  video4linux and not video4linux 2 API.

* video4linux2 virtual device
  http://sourceforge.net/projects/v4l2vd/

  This should be the successor of vloopback, unfortunately it seem not
  to work with linux 2.6.26:
  https://sourceforge.net/forum/forum.php?thread_id=2897804&forum_id=579262

  and also seems a little unmaintained.

* http://code.google.com/p/v4l2loopback/

  I don't know if there are applications using it, just read about it
  in this ML.

I wonder if someone can express an opinion on these projects, for
example to tell their current status / usability.

TIA, regards.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
