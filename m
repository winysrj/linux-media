Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ao2.it ([92.243.12.208]:38514 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbeKYE7V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 23:59:21 -0500
Received: from localhost ([::1] helo=jcn.localdomain)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1gQc6O-0007Yc-4f
        for linux-media@vger.kernel.org; Sat, 24 Nov 2018 18:52:20 +0100
Date: Sat, 24 Nov 2018 18:52:56 +0100
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Subject: [v4l-utils] Add options to v4l2-ctrl to save/load settings to/from
 a file
Message-Id: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

AFAIK every time a new v4l device is initialized (e.g. USB webcam
plugged in) the driver sets the controls to the default value decided by
the author in the source code.

It is then the responsibility of each v4l2 applications to save and
restore any variation to the controls values made by the user if this is
required.

I was looking for a more generic way to set some controls to non-default
values in a more persistent way, my main use case is to avoid *manually*
setting "Power Line Frequency" to 50Hz every time I plug in the webcam.

Something like what alsactrl[0] does with mixer settings.
Maybe pipewire will do that?

In the mean time, inspired by [1] I cleaned up the concept and published
it as v4l2-persistent-settings[2], the idea is that the user can save
the current state of a device and it would be restored automatically via
a udev rule the next time the device is initialized.

For that, the current device state has to be stored into a file.

For now I am massaging the output of "v4l2-ctl -l", saving that to
a file, and then parsing the file to generate something I can pass to
"v4l2-ctl --set-ctrl"; however it would be handier if v4l2-ctl had
a native mechanism to export and import settings.

v4l2ctrl from v4l2ucp[3] has options to save settings to a file and
reload them from a file, but I would like to use v4l2-ctl instead which
is actively maintained.

What about adding such options to v4l2-ctl?

Thank you,
   Antonio

[0] http://git.alsa-project.org/?p=alsa-utils.git;a=tree;f=alsactl;hb=HEAD
[1] https://superuser.com/questions/471597/linux-v4l-webcam-make-settings-stick
[2] https://git.ao2.it/v4l2-persistent-settings.git/
[3] https://sourceforge.net/projects/v4l2ucp/

-- 
Antonio Ospite
https://ao2.it
https://twitter.com/ao2it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
