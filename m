Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7QKREve000536
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 16:27:15 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7QKQ1qU025679
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 16:27:04 -0400
Received: by rv-out-0506.google.com with SMTP id f6so3032284rvb.51
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 13:27:04 -0700 (PDT)
Message-ID: <2df568dc0808261327w4fadadebm37b9516a5c4975b6@mail.gmail.com>
Date: Tue, 26 Aug 2008 14:27:03 -0600
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: saa7134_empress streaming via v4l2
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

Hello -

I have a RTD Technologies VFG7350 (saa7134 based, two channel, hardware
encoder per channel, no tuner).

Should v4l2 show MPEG extended controls for a saa7134_empress device? If so,
any hints about how to restore the controls?

Below is control listing in 2.6.25-gentoo-r7 + v4l-dvb:
----------------------------------------
$ v4l2-ctl  --list-ctrls --device=/dev/video2

User Controls

                     brightness (int)  : min=0 max=255 step=1 default=128
value=128
                       contrast (int)  : min=0 max=127 step=1 default=68
value=68
                     saturation (int)  : min=0 max=127 step=1 default=64
value=64
                            hue (int)  : min=-128 max=127 step=1 default=0
value=0
                         volume (int)  : min=-15 max=15 step=1 default=0
value=0
                           mute (bool) : default=0 value=1
                         mirror (bool) : default=0 value=0

MPEG Encoder Controls
----------------------------------------

Below is control listing in 2.6.22-gentoo-r10 (also shows "private
controls"):
----------------------------------------
$ v4l2-ctl  --list-ctrls --device=/dev/video2
                     brightness (int)  : min=0 max=255 step=1 default=128
value=128
                       contrast (int)  : min=0 max=127 step=1 default=68
value=68
                     saturation (int)  : min=0 max=127 step=1 default=64
value=64
                            hue (int)  : min=-128 max=127 step=1 default=0
value=0
                         volume (int)  : min=-15 max=15 step=1 default=0
value=0
                           mute (bool) : default=0 value=1
                         mirror (bool) : default=0 value=0
                         invert (bool) : default=0 value=0
             y_offset_odd_field (int)  : min=0 max=128 step=0 default=0
value=0
            y_offset_even_field (int)  : min=0 max=128 step=0 default=0
value=0
                       automute (bool) : default=1 value=1
----------------------------------------

Any hints also about how to restore the "private controls" (invert -
automute)?

Thanks.
- Gordon
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
