Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33343 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbdAWWOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 17:14:02 -0500
Received: by mail-pg0-f67.google.com with SMTP id 194so14736061pgd.0
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2017 14:14:01 -0800 (PST)
Date: Tue, 24 Jan 2017 09:13:50 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Dreamcat4 <dreamcat4@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Mysterious regression in dvb driver
Message-ID: <20170123221335.GA10945@Belindas-MacBook-Pro.local>
References: <CAN39uTpT1W9m+_OQvP_4pbPiOPKjdTGA6tyJ9VJeGq+AZQXfuw@mail.gmail.com>
 <CAN39uTpwe0CjqmC=ajamfN8UrsarwaDZb5YRCMfTNQ2Edyph4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN39uTpwe0CjqmC=ajamfN8UrsarwaDZb5YRCMfTNQ2Edyph4g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 23, 2017 at 12:21:35PM +0000, Dreamcat4 wrote:
> Hi again,
> 
> Installed Antergos (arch) linux today, and its still same issues. That
> is with an even newer 4.8 kernel. No HD channels, I2C error in dmesg,
> CRC error during w_scan tuning. (when its tuning the HD channels).
> 
> So I'm hesitant to report it as a bug under ubuntu bug reporter. Since
> its not just limited to debian-based distros.
> 
> My main question is whats actually all the files on the disk /
> filesystem that are involved? If not in the kernel. Then I could go
> back and grab them all from ubuntu 14.04 (works), to try in 14.10
> (time of first breakage). Replacing one file at a time.
> 
> Wheras... if it is in the kernel then what else was added later on
> that broke this? And why is the newer 4.2 updated kernel in the old
> 14.04 (+.3) still working then? Just doesn't add up / make sense to
> me.
> 
> I would be very grateful if anyone here could please shed some more
> light on the matter.

If it is a cross-distro breakage then probably the kernel bugzilla
might be the right place to file an issue. However you should first
spend a little time to clarify exactly where the issue is occurring.

First, can you find the usb-id or pci-id for the device, as well as
the marketing name. It's important for others to be able to identify
the device unambiguously. dmesg from a working kernel should show this.
Once you have that, run lspci -vvv or lsusb -v for that device and
save the output.

Next I suggest making a list of the kernels you have tried and whether
the device is working or not with that kernel. You want the most detailed
version number you can find, from the kernel package name or changelog.
The release date for the packages would probably be helpful too.

Then you should look for the latest working and earliest non-working
version. Since you are using distro kernels, which will have many
differences from the one published by kernel.org, it may be worth trying
to find the git repository and the git tag that matches the kernels on
either side of the break. This will allow easy diffing of the code.
The changelog for the kernel package should have dates and perhaps even
git commit ids that will help with that quest. If you get stuck on this
just post your results so far, someone may be able to help.

It might also be useful to capture dmesg logs for those two (working/
nonworking) versions so you can look for the place where things go awry.

HTH
Vince
