Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LARGeO019100
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 06:27:16 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LAR5ds018582
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 06:27:05 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 378F511A2DF8
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 11:27:04 +0100 (BST)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tvhmQpSpXgFn for <video4linux-list@redhat.com>;
	Tue, 21 Oct 2008 11:27:04 +0100 (BST)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 0230D11A2BF8
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 11:27:03 +0100 (BST)
Message-ID: <48FDAE77.8030207@pickworth.me.uk>
Date: Tue, 21 Oct 2008 11:27:03 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <48FD07FA.9090402@pickworth.me.uk> <48FD9ABA.70804@hhs.nl>
In-Reply-To: <48FD9ABA.70804@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: gspca V2 vs V1: webcam picture very dark
Reply-To: ian@pickworth.me.uk
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

Hans de Goede wrote:
> > Ian Pickworth wrote:
> > Hi Ian,
> >
> > Thanks for including so much details in you report, this certainly makes
> > things much easier for us!

So far your advice back is 100% - thank you very much.

> > This is normal, you have a revison 12a spca561 (I can tell from your
> > usb-id), this does not have brightness nor contrast controls, hence they
> > show as 0. It does have exposure and gain controls which used to be
> > mapped to contrast and brightness in gspcav1 as there was no way to
> > express these controls in v4l1, the new gspcav2 exports these as
> > exposure and gain, iow as what they are.
> >
> > However since you're using a v4l1 application, you cannot control these
> > now. You can use a separate v4l2 controlpanel application (google for,
> > download, and install v4l2ucp) to control these settings. You can run
> > this in parallel to spcaview. You will want to crank up exposure, I
> > really need to add software autoexposure to libv4l for these cams to
> > adjust this automatically to lighting conditions.
> >

Downloaded v4l2ucp, ./configure, make and then ran v4l2ucp. Bingo -
webcam is way better than it ever was under gspca V1, and I can now
adjust it for background light conditions.

Result - many thanks. Now Skype, mplayer and spcaview all show crisp
pictures.

Now I just have to work out how to get cheese to work. No good
documentation for adjusting the gstreamer pipe it uses.
Seems to be picking up the TV tuner card rather than the webcam -
despite setting the source in gstreamer-propeties (and the test there
working). Ho hum - more digging.

Thanks
Regards
Ian

(Original reply not sent to list - sorry)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
