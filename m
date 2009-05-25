Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4P21lNc021506
	for <video4linux-list@redhat.com>; Sun, 24 May 2009 22:01:47 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4P21YLv017669
	for <video4linux-list@redhat.com>; Sun, 24 May 2009 22:01:34 -0400
Received: by yw-out-2324.google.com with SMTP id 3so1838617ywj.81
	for <video4linux-list@redhat.com>; Sun, 24 May 2009 19:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0905230826t6338ff00ye7db7c2eb2a62695@mail.gmail.com>
References: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
	<829197380905220640k5b19e190y6382f969fc823e37@mail.gmail.com>
	<d9def9db0905230826t6338ff00ye7db7c2eb2a62695@mail.gmail.com>
Date: Mon, 25 May 2009 10:01:33 +0800
Message-ID: <b90a809a0905241901n2e9b14cdx24622e26c826a45c@mail.gmail.com>
From: =?GB2312?B?vrDOxMHW?= <wenlinjing@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: Re: How to acces TVP5150 .command function from userspace
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

Thank you for reply=A3=A1
I`m sorry that I did not describe my problem clearly.

In tvp5150 driver=A3=ACthe v4l2 controls(VIDIOC_G_CTRL like)that i need are
already implemented. part of the driver as follow:
static int tvp5150_command(struct i2c_client *c,unsigned int cmd, void *arg=
)
{
    struct tvp5150 *decoder =3D i2c_get_clientdata(c);

    switch (cmd) {

    case 0:
    case VIDIOC_INT_RESET:
    ...
    case VIDIOC_G_CTRL:
    ...
}
static struct i2c_driver driver =3D {
    .driver =3D {
        .name =3D "tvp5150",
    },
    .id =3D I2C_DRIVERID_TVP5150,

    .attach_adapter =3D tvp5150_attach_adapter,
    .detach_client =3D tvp5150_detach_client,

    .command =3D tvp5150_command,
};

I want to access the tvp5150_command function in userland . I opened
/dev/i2c-0 and called ioctl like that:
if (ioctl(file,I2C_SLAVE_FORCE,addr) < 0) {    /*addr is tvp5150 address*/
    exit(1);
 }

 if (ioctl(file,VIDIOC_G_CTRL,addr) < 0)
...
It`s absolute wrong but I don`t know how to call VIDIOC_G_CTRL control.

Regards,
william











2009/5/23 Markus Rechberger <mrechberger@gmail.com>

> 2009/5/22 Devin Heitmueller <dheitmueller@kernellabs.com>:
> > On Fri, May 22, 2009 at 3:50 AM, =BE=B0=CE=C4=C1=D6 <wenlinjing@gmail.c=
om> wrote:
> >> Hi,
> >>
> >> I am working with a video capture chip TVP5150. I want to adjust the
> >> "Brightness" "Contrast" "Saturation" and "hue" in user space.
> >> In TVP5150 drivers ,the V4l2 commands are in function
> tvp5150_command.And
> >> this function is a member of struct i2c_device.
> >>
> >> The linux is 2.6.19.2.
> >> I write my code according kernel document
>  Documentation/i2c/dev-interface
> >> But I can`t access tvp5150_command.
> >> How can i acces i2c_device .command  function from user space?
> >
> > I thought those controls were already implemented in the tvp5150
> > driver, although I could be mistaken (I would have to look at the
> > code).  If not, it would probably be much easier to just add the
> > commands to the driver than to attempt to program the chip from
> > userland (the datasheet for the tvp5150 is freely available).
> >
>
> those are definitely implemented, I remember there was a problem with
> a too dark videopicture years ago and it was a bug in the tvp5150...
>
> Also by looking at it:
> V4L2_CID_BRIGHTNESS
> V4L2_CID_CONTRAST
> V4L2_CID_SATURATION
> V4L2_CID_HUE
>
> are supported.
>
> Markus
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
