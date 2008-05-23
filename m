Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4NCtGAS011899
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 08:55:17 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4NCs2QD008538
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 08:54:02 -0400
Received: by rv-out-0506.google.com with SMTP id f6so713511rvb.51
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 05:54:02 -0700 (PDT)
Message-ID: <d9def9db0805230554w34519e73nabccdfce93999643@mail.gmail.com>
Date: Fri, 23 May 2008 14:54:02 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: ralf@ark.in-berlin.de
In-Reply-To: <20080523112305.GA25477@ark.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523112305.GA25477@ark.in-berlin.de>
Cc: video4linux-list@redhat.com
Subject: Re: hardware noob needs orientation
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

Hi Ralf,

On 5/23/08, Ralf Stephan <ralf@ark.in-berlin.de> wrote:
> Hello,
> please excuse me asking possibly basic questions. My problem is
> 1. the need to use a specific camera (having Cinch cable/adapter)
> 2. the impossibility of installing a card in this box (fanless)
>
> Is there a supported Cinch/USB converter you can recommend?
>

With Chinch you mean Composite?

(Look at analog TV Devices)
http://mcentral.de/wiki/index.php5/Em2880#Devices

Those devices are also manufacturer supported. So even if you run into
trouble with TV applications just put a request onto the corresponding
em28xx Mailinglist which is specialized on those devices.

> As the camera is placed >4m from the box, which configuration
> would be best? Short Cinch, then long USB, with intermediate hub?
>

short USB Cable and long Chinch cable should be fine, I used a cheap
Chinch cable for testing Compiste and a short USB Cable

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
