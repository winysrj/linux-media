Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOHah0C021668
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:36:43 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOHUaBc000976
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:30:36 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1180093qwe.39
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 09:30:36 -0800 (PST)
Message-ID: <b9476b930812240930l60e1ca74ua53c4b16c40ecc85@mail.gmail.com>
Date: Wed, 24 Dec 2008 23:00:36 +0530
From: "Manas Bhattacharya" <bhattacharya.manas@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: help: v4l2 pixel format setting
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

Hi all
  I  need help in setting pixel values to my wecam. My camera is Frontech
ecam jil 2220 model
The PC cam controller installed  Sn9c120  .Any pixel format i want to
set(say yuyv,yuv420 etc) VIDIOC_S_FORMAT returns me Bayer Rgb (sbggr8)
format .can u please help me in identifying the problem
       Manas Bhattacharya
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
