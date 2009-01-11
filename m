Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:15253 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZAKUfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 15:35:19 -0500
Received: by ti-out-0910.google.com with SMTP id b6so11745260tic.23
        for <linux-media@vger.kernel.org>; Sun, 11 Jan 2009 12:35:17 -0800 (PST)
Subject: Re: [PATCH] pwc: add support for webcam snapshot button (2)
From: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <2ac79fa40901092218y6af40570m5cbe5aeb598038b2@mail.gmail.com>
References: <2ac79fa40901092218y6af40570m5cbe5aeb598038b2@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 03:35:03 +0700
Message-Id: <1231706104.10496.91.camel@AcerAspire4710>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Please review and consider to apply my patch, for following reasons:
1. Nobody complains anymore about it :)
2. Tested to guarantee working with 2 kinds of Logitech webcam.
3. It's quite clearly to see that event input support won't break
anything existing (and you still have option to disable it in kernel
configuration if you don't like).
4. Consistency of webcam snapshot button support as an event input
device with other webcam drivers.
5. Nowadays, many manufacturers are making webcams with a button on it
to use in their Windows software (e.g. the software Logitech's Quickcam
for Logitech webcams). The webcam snapshot button is very convenient
when you want to take an interesting moment on someone or something by
one hand (like a digital camera). I've asked a question about this
problem and it seems that solutions are still null for Linux.
But now I'm happy because I've found the way to use webcam snapshot
button with webcam applications (like Cheese) provided that my webcam
button is supported as an input device.
----------
Sharing my experience on Ubuntu 8.10
1. Install gizmod (http://gizmod.sourceforge.net)
sudo apt-get install gizmod
2. Connect webcam and run gizmod at debug mode as superuser:
sudo gizmod -g
3. Open webcam with Cheese and press the snapshot button (button of pwc
webcam is only usable when webcam is being open)
When button is pressed, gizmod shows:
onEvent: Standard -- /dev/input/event12 | [EV_KEY] <BTN_0> c: 0x100 v:
0x1
and when button is released, gizmod shows:
onEvent: Standard -- /dev/input/event12 | [EV_KEY] <BTN_0> c: 0x100 v:
0x0
Pay attention to "c: 0x100 v:0x0" in the above line, we'll use these
numbers to configure gizmod.
4. Create /etc/gizmod/modules.d/010-Snapshot-Cheese.py with the
following content (the numbers 0x100 and 0x0 are used):
    #***
  #*********************************************************************
#*************************************************************************
#*** 
#*** GizmoDaemon Config Script
#*** Snapshot Cheese config
#***
#*****************************************
  #*****************************************
    #***

"""

  Written by Pham Thanh Nam (phamthanhnam.ptn@gmail.com)
  
"""

############################
# Imports
##########################

from GizmoDaemon import *
from GizmoScriptRunningApplication import *
import subprocess

ENABLED = True
VERSION_NEEDED = 3.2
INTERESTED_CLASSES = [GizmoEventClass.Standard]
INTERESTED_APPLICATION = "cheese"

############################
# SnapshotCheese Class definition
##########################

class SnapshotCheese(GizmoScriptRunningApplication):
"""
Snapshot Cheese Event Mapping
"""

############################
# Public Functions
##########################

def onDeviceEvent(self, Event, Gizmo = None):
"""
Called from Base Class' onEvent method.
See GizmodDispatcher.onEvent documention for an explanation of this
function
"""

# process the key
   if (Event.Code == 0x100) and (Event.Value == 0x0):
   Gizmod.Keyboards[0].createEvent(GizmoEventType.EV_KEY,
GizmoKey.KEY_SPACE)
   return True
   else:
   # unmatched event, keep processing
return False 

############################
# Private Functions
##########################

def __init__(self):
""" 
Default Constructor
"""

GizmoScriptRunningApplication.__init__(self, ENABLED, VERSION_NEEDED,
INTERESTED_CLASSES, INTERESTED_APPLICATION)

############################
# SnapshotCheese class end
##########################

# register the user script
SnapshotCheese()
5. Kill gizmod by Ctrl-C and run it again at normal mode:
sudo gizmod
6. Focus to active Cheese window, uncheck countdown option in Cheese and
try the snapshot button. Happy shots!
----------

