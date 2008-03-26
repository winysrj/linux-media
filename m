Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QEGP1J001751
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 10:16:25 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QEGEOF026085
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 10:16:15 -0400
Received: by gv-out-0910.google.com with SMTP id l14so715488gvf.13
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 07:16:14 -0700 (PDT)
Message-ID: <8bf247760803260716x1fba9aa9u4d49e7e558fd5867@mail.gmail.com>
Date: Wed, 26 Mar 2008 19:46:13 +0530
From: Ram <vshrirama@gmail.com>
To: "JoJo jojo" <onetwojojo@gmail.com>
In-Reply-To: <226dee610803240531g2c27e1s7a475309c9709e48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bf247760803240521mfde8dd0l9ee16106c88f2283@mail.gmail.com>
	<226dee610803240531g2c27e1s7a475309c9709e48@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: firmware update camera doubts
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
The problem is everytime, the device is opened, the device is powered on
So everytime i have to do a firmware update.

The new camera driver design does this. earlier before linux-2.6.23.
This was not
done.

Im not really sure if this is correct.

Regards,
sriram


On Mon, Mar 24, 2008 at 6:01 PM, JoJo jojo <onetwojojo@gmail.com> wrote:
>
> On Mon, Mar 24, 2008 at 5:51 PM, Ram <vshrirama@gmail.com> wrote:
>  > Hi,
>  >    Im writing a camera sensor driver for omap - which needs to update
>  >  a firmware to the camera.
>  >   The firmware size is around 50K bytes.
>  >
>  >    Which is the best place to update firmware in the sensor driver in
>  >  the latest V4L2 for linux-2.6.23?
>  >
>  >    Should it be done in XXX_configure function or after power_on ( );
>  >
>  >   Some drivers do common initializations in the XXX_configure function.
>  >   But am not really sure if XXX_configure is the right place since updating
>  >   firmware takes time (approx 5/10 seconds)
>  >
>  >
>  >   Please advice,
>  >
>  >
>  >  Regards,
>  >  sriram
>
>  after its initialized, update the firmware & reset the camera/device
>
>  -JoJo
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
