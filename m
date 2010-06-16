Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37610 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0FPKnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 06:43:10 -0400
Received: by gwj15 with SMTP id 15so3843602gwj.19
        for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 03:43:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com>
Date: Wed, 16 Jun 2010 11:43:09 +0100
Message-ID: <AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com>
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
From: =?UTF-8?Q?Pedro_C=C3=B4rte=2DReal?= <pedro@pedrocr.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 16, 2010 at 11:24 AM, Pedro Côrte-Real <pedro@pedrocr.net> wrote:
> I bought an Asus My Cinema U3100 mini,
> which seems to be correctly recognized by the dib0700 driver in Ubuntu
> 10.04 (kernel 2.6.32-22-generic). I can try the latest upstream kernel
> to see if anything has changed.

Just tested the Ubuntu packaged kernel.org git snapshot of 2.6.35
(2010-06-15 15:05) and much the same results happen. Scanning throws
the same timeout and mplayer the same error messages although it now
quits after a while:

"""
$ mplayer dvb://
MPlayer SVN-r1.0~rc3+svn20090426-4.4.3 (C) 2000-2009 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing dvb://.
dvb_tune Freq: 842000000
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, return 0 bytes


Exiting... (End of file)
"""

vlc for some reason no longer shows the error messages but it doesn't
work either.

One thing I forgot to mention before is that femon does show a lock:

pedrocr@nash:~$ femon -H
FE: DiBcom 7000PC (DVBT)
status       | signal   0% | snr   1% | ber 2097151 | unc 0 |
[... after tuning ...]
status S     | signal  16% | snr   1% | ber 2097151 | unc 0 |
status S     | signal  25% | snr   1% | ber 2097151 | unc 0 |
status S     | signal  24% | snr   1% | ber 2097151 | unc 0 |
status SC    | signal  24% | snr   1% | ber 2097151 | unc 0 |
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 6 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 11 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 7 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  23% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
[... after changing to a better and amplified antenna ...]
status  C Y  | signal  66% | snr   0% | ber 2097151 | unc 0 |
status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  65% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK
status SC YL | signal  64% | snr   0% | ber 2097151 | unc 0 | FE_HAS_LOCK

(Showing snr in % seems very strange here)

One thing I forgot to mention is that I bought the U3100 at a retailer
and it seems to have been opened before so there is a chance it is
broken somehow.

Pedro
