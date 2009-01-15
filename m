Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FMkeG3008473
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 17:46:40 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0FMk5Fh002773
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 17:46:06 -0500
Received: by bwz13 with SMTP id 13so3879356bwz.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 14:46:05 -0800 (PST)
Message-ID: <d9def9db0901151445o33a8909er8bd4370616c1b71f@mail.gmail.com>
Date: Thu, 15 Jan 2009 23:45:44 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "=?ISO-8859-1?Q?P=E1draig_Brady?=" <P@draigbrady.com>
In-Reply-To: <496FB713.5020609@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <20090115163348.5da9932a@tuvok>
	<09CD2F1A09A6ED498A24D850EB10120817E30B7506@Colmatec004.COLMATEC.INT>
	<20090115175121.25c4bdaa@tuvok> <496FB713.5020609@draigBrady.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: How to identify USB-video-devices
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

On Thu, Jan 15, 2009 at 11:22 PM, Pádraig Brady <P@draigbrady.com> wrote:
> Carsten Meier wrote:
>> Storing device-file-names is also not an option because they are
>> created dynamicly.
>
> You use udev rules to give persistent names.
>
> Here is my /etc/udev/rules.d/video.rules file,
> which creates /dev/webcam and /dev/tvtuner as appropriate.
>
> KERNEL=="video*" SYSFS{name}=="USB2.0 Camera", NAME="video%n", SYMLINK+="webcam"
> KERNEL=="video*" SYSFS{name}=="em28xx*", NAME="video%n", SYMLINK+="tvtuner"
>
> To find distinguishing attributes to match on use:
>
> echo /sys/class/video4linux/video* | xargs -n1 udevinfo -a -p
>

yep, this is more or less what I meant too, although I didn't know
about udevinfo. I wonder if the output is consistent during the last
8(?) kernel releases because the sysfs structure changed, so I doubt
that actually.

regards,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
