Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab1GQU61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 16:58:27 -0400
Message-ID: <4E234D46.9070104@redhat.com>
Date: Sun, 17 Jul 2011 22:59:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>
Subject: Start of v4l-utils-0.9.x devel cycle, break of libv4lconvert ABI
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

With the upcoming support for libv4l2 plugins we need to
break the ABI for libv4lconvert, this is a good moment
to start a bit more unstable v4l-utils / libv4l tree
where we can make some other changes as well.

v4l-utils follows the classic odd unstable / even stable release numbering,
this is the start of a new 0.9.x dev cycle leading to a 0.10.x (or maybe a
1.x) release. The plan for 0.9.x is to:
1) Keep the libv4l1 and libv4l2 ABI's compatible with 0.8.x
2) Change the libv4lconvert ABI, changing the soname to libv4lconvert.so.1
    (from libv4lconvert.so.0), this is needed to be able to add plugin
    support to libv4l2
3) Allow for somewhat more adventurous changes, until later in the 0.9.x
    cycle, when things should stabilize again

Note WRT 2):
a) There is no promise of a stable libv4lconvert.so.1 ABI
    until 0.10.0 is released! Note
b) This is not really a big deal, only qv4l2 (which is shipped together with
    libv4lconvert) and Jean-Francois Moine's svv use libv4lconvert directly
    AFAIK.

I've already pushed the initial plugin support to the v4l-utils git repo,
other things I plan to do is:
-think about how libv4lconvert / control / processing fit together,
  probably redesign parts and allow for processing plugins, which can'
  then also bring along their own fake controls.
-change how the upside down table works, making it more flexible, in
  the form of being able to say:
  "if system_vendor is in this list and product_name is in this list,
  and usb vendor+prod_id is in this list then it is upside down"
  This is mostly for Asus where they tend to mix and match a given
  set of internal laptop webcams against there entire portfolio of
  laptops, usually in a chassis which has an upside down mount for the cam,
  but not always ...
-maybe, just maybe add support for software autofocus
  (this would be a new processing plugin)

Regards,

Hans
