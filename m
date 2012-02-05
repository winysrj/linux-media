Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50038 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2BES4G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 13:56:06 -0500
Received: by eaah12 with SMTP id h12so2208918eaa.19
        for <linux-media@vger.kernel.org>; Sun, 05 Feb 2012 10:56:04 -0800 (PST)
Message-ID: <4F2ED0BC.1060104@gmail.com>
Date: Sun, 05 Feb 2012 19:55:56 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	David Cohen <dacohen@gmail.com>, tuukkat76@gmail.com,
	Heungjun Kim <riverful.kim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [ANN] Notes on the control classes and new camera controls on #v4l2-meeting
 2012-02-03
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We had an IRC discussion (Sakari, Laurent and me) regarding the control
classes in general and new controls that are required by more advanced
camera sensors [3] (usually running a customizable firmware). More 
details on the agenda can be found in the invitation message [1].

There was an agreement on selected topics however some issues remain 
more or less open. The full meeting log can be found at [2].

The conclusions from the meeting could be summarized as follows:

- We are having multiple levels of controls that interact with each other,
  on the lowest level are controls that are directly mapped to hardware
  blocks - analogue gain for example; on the highest level are controls
  that influence complex software algorithms implemented in a firmware;
  The control classes are not much helpful in logical classification of 
  the various level controls, it is often difficult to clearly associate
  particular control with specific class. Therefore the controls [3] 
  documentation should talk about of some sort of profile indicating which
  controls to expose on which kind of device.

- The selection API should be used for specifying window-of-interest for
  auto focus, exposure and white balance algorithms;

  - We're going to use separate selection target base for AF, AE, AWB
    and reserve a pull of targets for each of them, e.g. 256;
  
  - A bitmask control can be used to determine which of multiple 
    rectangles are currently in use;

  - In order to associate the selection targets with specific controls
    (AF, AE, AWB) the queryctrl ioctl may be extended to return the
    selection target base with the above mentioned bitmask control.
    The number of bits in the control will indicate maximum number of
    selection targets for each algorithm;	

  - Single point coordinates, where needed, should be specified by 
    rectangle width and height set to 0.
   
- Control names should not generally be prefixed with a control class
  name, as it is not always clear which class a control should belong to;

- As there is no better alternative solution it has been initially agreed
  to keep two new control classes: the image source and image processing 
  class [4];

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg42735.html
[2] http://www.retiisi.org.uk/v4l2/notes/v4l2-control-classes-camera-2012-02-03.txt
[3] http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/camera-controls
[4] http://www.mail-archive.com/linux-media@vger.kernel.org/msg42823.html
    http://www.mail-archive.com/linux-media@vger.kernel.org/msg42802.html

--

Regards,
Sylwester

