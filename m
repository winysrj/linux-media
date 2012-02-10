Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:37118 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670Ab2BJSZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 13:25:59 -0500
Date: Fri, 10 Feb 2012 18:25:56 +0000
From: Tony Houghton <h@realh.co.uk>
To: Jan Panteltje <panteltje@yahoo.com>, linux-media@vger.kernel.org
Subject: Re: General question about IR remote signals  from USB DVB tuner
Message-ID: <20120210182556.005b6b47@junior>
In-Reply-To: <1328891689.25568.YahooMailClassic@web39302.mail.mud.yahoo.com>
References: <1328891689.25568.YahooMailClassic@web39302.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/KpNTESlefx2=abKP5L39Bpp"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/KpNTESlefx2=abKP5L39Bpp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, 10 Feb 2012 08:34:49 -0800 (PST)
Jan Panteltje <panteltje@yahoo.com> wrote:

> I recently bought a Terratec cinergy S2 USB  HD receiver.
> I got everything working just fine in Linux and get excellent
> reception.
> This thing came with a small remote controller, and I notice
> that the  output of this remote appears as ASCII characters on stdin,
> on any terminal that I open...
> Wrote a small GUI application that sets the input focus to a hidden
> input field, and can process the numbers from this remote that way,
> but of course this only works if the mouse has selected that
> application.
> 
> Thinking about this I think that the driver dumps the received remote
> control characters simply to stdout.

Something fairly low level processes the input events and converts them
to keyboard events. IIRC this happens on the console as well as in X.

> If this is so, does there perhaps exists a /dev/dvb/adapterX/remoteX
> interface in the specs so I could modify that driver to send the codes
> there?

The events can be read from /dev/input/eventX. You can do something like
parse /proc/bus/input/devices to work out which device corresponds to
your remote. The structure of the events etc is defined in
/usr/include/linux/input.h. The EVIOCGRAB ioctl is useful to grab the
events exclusively for your application and stop them appearing on the
console.

I don't know exactly what the fields in input_event are supposed to
mean, and IME their significance can vary with remote and with kernel
version. If you can find more information about this, please send a copy
to me because I'm about to unsubscribe from linux-media. If you can't
find the information you'll probably find it useful to experiment with
the attached python script (treat as Public Domain).

--MP_/KpNTESlefx2=abKP5L39Bpp
Content-Type: text/x-python
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=testdevinput.py

#!/usr/bin/env python

import os
import struct
import sys

SIZEOF_INPUT_EVENT = struct.calcsize('llHHi')
# time (2 * long), type, code, value

quiet = False

def main_loop(fd):
    while True:
        s = os.read(fd, SIZEOF_INPUT_EVENT)
        if len(s) != SIZEOF_INPUT_EVENT:
            print >>sys.stderr, "Read %d bytes, expected %d" % \
                    (len(s), SIZEOF_INPUT_EVENT)
            break
        [tsec, tusec, type, code, value] = struct.unpack('llHHi', s)
        if not quiet or type:
            print "T:%10.2f t:%02x c:%02x v:%02x" % \
                    (tsec + float(tusec) / 1000000, type, code, value)

def main():
    if sys.argv[1] == '-q':
        global quiet
        quiet = True
        filename = sys.argv[2]
    else:
        filename = sys.argv[1]
    fd = os.open(filename, os.O_RDONLY)
    main_loop(fd)

if __name__ == '__main__':
    main()

--MP_/KpNTESlefx2=abKP5L39Bpp--
