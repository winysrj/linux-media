Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:34253 "EHLO
        smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752837AbdC0Jza (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 05:55:30 -0400
From: "Haeberle Heinz (PT-MT/ELF1)" <Heinz.Haeberle@de.bosch.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Todor Tomov <todor.tomov@linaro.org>
Subject: Start development on dragonboard 410c with OV5645 camera
Date: Mon, 27 Mar 2017 09:54:45 +0000
Message-ID: <bb2ff610de9f45e680b5f3194eac9667@FE-MBX1007.de.bosch.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I want to get into the development of the v4l driver for OV5645 camera. I w=
ant to work on features =A0like zoom and manual exposure time / gain contro=
l.=20
And get our own camera module connected later on as well (mostly a hardware=
 issue)=20

The starting point for me is a dragonboard 410c (which I got already) and t=
he Mezzanine MIPI Adapter board plus OV5645 Camera module (which I expect t=
o get this week)

I will first - as soon as I get the camera - follow the set up CSI procedur=
e on https://builds.96boards.org/releases/dragonboard410c/linaro/debian/16.=
09/ of course

Could somebody give me some hints what would be the best steps to get into =
a position to modify driver code.

I am new to the v4l driver development, but have some experience with drive=
r development in Linux (although it got somehow rusty ;-) )
I usually like to start with modules, but I have seen the driver is statica=
lly linked. Any hints on that?

Is development usually done native or via cross compile?=20
Heinz
