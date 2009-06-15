Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5FFCtIx002332
	for <video4linux-list@redhat.com>; Mon, 15 Jun 2009 11:12:55 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n5FFC243026915
	for <video4linux-list@redhat.com>; Mon, 15 Jun 2009 11:12:39 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1893305qwd.39
	for <video4linux-list@redhat.com>; Mon, 15 Jun 2009 08:12:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244834106.19673.1320127457@webmail.messagingengine.com>
References: <1244834106.19673.1320127457@webmail.messagingengine.com>
Date: Mon, 15 Jun 2009 11:12:39 -0400
Message-ID: <829197380906150812w3b524b9cw41e7e3b5e3d65f03@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Kay Wrobel <kwrobel@letterboxes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L Mailing List <video4linux-list@redhat.com>
Subject: Re: SUCCESS - KWorld VS-USB2800D recognized as PointNix Intra-Oral
	Camera - No Composite Input
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

On Fri, Jun 12, 2009 at 3:15 PM, Kay Wrobel<kwrobel@letterboxes.org> wrote:
> Dear folks @ V4L List,
>
> I'd just quickly like to let everybody know that I am now able to
> capture S-Video AND Composite video from my KWorld VS-USB2800D using the
> latest development snapshot of v4l-dvb. Kudos to Douglas Schilling
> Landgraf for helping me with the steps to download and recompile the
> v4l-dvb drivers, specifically the em28xx driver which pertains to my
> capture device.
>
> As a nice side effect, I am also now able to select a new audio capture
> device embedded in the VS-USB2800D device instead of using the extra
> line-in wire that comes out of the device. I used to have to feed that
> cable into the line-in of my sound card. Now, I get an actual device
> called "Empia Em28xx Audio Empia 28xx Capture (ALSA)" in Ubuntu's Sound
> Preferences dialog.

Hello Kay,

Yeah, I added support for that device last week.  However, the fact
that the audio device is being created is actually a bug.  That
particular board does not support providing the audio over the USB
port.  I submitted a PULL request last night to prevent the audio
device from being created for that board.

Are you saying that the audio device is actually delivering sound?  If
so, I definitely would like you to contact me since I have no idea how
that is possible and would want to know more.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
