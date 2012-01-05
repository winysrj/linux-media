Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51218 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab2AEXOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 18:14:36 -0500
Received: by qcqz2 with SMTP id z2so622001qcq.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 15:14:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyz+Uy9b8CP7N-BZd0M=J=55aKr0LpWi7AqAtKQYXN+Mw@mail.gmail.com>
References: <CAGoCfiw7c8=o5doJcYctmRbsj-idmxsRKVE5OzCOQ_xhLGBxMg@mail.gmail.com>
	<4F0627E5.9050004@yahoo.com>
	<CAGoCfixsMvcxAV2ww8KVCKGWdzX3dxjVu9coDN1Fi32a5jQHpQ@mail.gmail.com>
	<CAGoCfiyz+Uy9b8CP7N-BZd0M=J=55aKr0LpWi7AqAtKQYXN+Mw@mail.gmail.com>
Date: Fri, 6 Jan 2012 00:14:36 +0100
Message-ID: <CAHF9RencXhtfbq0s788a5F37_LVvXPqO-vJjsZDSntA_Hm2-gg@mail.gmail.com>
Subject: Re: Support for RC-6 in em28xx driver?
From: =?ISO-8859-1?Q?Simon_S=F8ndergaard?= <john7doe@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 5, 2012 at 11:51 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Jan 5, 2012 at 5:48 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> Yes, it can.  Like almost every IR receiver provided by the linux
>> media subsystem, the 290e is configured with the keymap of the
>> pinnacle remote *by default*.  There are userland tools (e.g.
>> ir-keytable) which allow you to load keymaps in for other remotes.
>
> I should clarify my previous statement by saying that the support for
> other remotes is constrained by what the hardware supports.  If the IR
> receiver hardware only supports RC5 and NEC, then you can't use an RC6
> remote with it.
>
> But to your point, I actually used my Hauppauge remote when I
> originally wrote the em2874 IR support (and only at the end
> reconfigured it to use the PCTV remote).
>
> Devin
>

Chris,

If the driver supported RC6 out of the box, the I should be able to
use the hp remote on my mythbuntu machine:

sudo ir-keytable -p rc-6 -c -w /lib/udev/rc_keymaps/rc6_mce

/etc/rc_maps.cfg could be updated to make the choice permanent

Br,
/Simon
