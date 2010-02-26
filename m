Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965843Ab0BZTmz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 14:42:55 -0500
Message-ID: <4B882457.1050006@hhs.nl>
Date: Fri, 26 Feb 2010 20:43:19 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.7.90 (which includes libv4l-0.7.90)
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm happy to announce the first (test / beta) release of v4l-utils,
v4l-utils is the combination of various v4l and dvb utilities which
used to be part of the v4l-dvb mercurial kernel tree and libv4l.

I encourage people to give this version a spin. I esp. would like
feedback on which v4l / dvb utilities should end up being installed
by make install. For now I've stuck with what the Makefile in v4l2-apps
did. See README for a list of all utilities and if they are currently
installed or not.

If you are doing distribution packaging of libv4l, note that the
good old libv4l tarbal releases are going away, libv4l will now
be released as part of v4l-utils, and you are encouraged to
package that up completely including the included utilities. As
I'm doing distro package maintenance  myself I know this is a pain,
but in the long run having a single source for v4l + dvb userspace tools
and libraries is for the best.

New this release:

v4l-utils-0.7.90
----------------
* This is the first release of v4l-utils, v4l-utils is the combination
   of various v4l and dvb utilities which used to be part of v4l-dvb
   mercurial kernel tree and libv4l.
* This first version is 0.7.90, as the version numbers continue were libv4l
   as a standalone source archive stops.
* libv4l changes:
   * Add more laptop models to the upside down devices table
   * Fix Pixart JPEG ff ff ff xx markers removal, this fixes the occasional
     corrupt frame we used to get (thanks to Németh Márton)
   * Enable whitebalance by default on various sonixj based cams
   * Enable whitebalance + gamma correction by default on all sonixb cams
   * Enable gamma correction by default on pac7302 based cams

Go get it here:
http://people.fedoraproject.org/~jwrdegoede/v4l-utils-0.7.90.tar.bz2

You can always find the latest developments here:
http://git.linuxtv.org/v4l-utils.git

Note, it would be good to have some place at linuxtv.org to host the
tarbals, if someone could help me set that up that would be great.

Regards,

Hans

