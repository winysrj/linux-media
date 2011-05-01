Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51000 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1EAScK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 14:32:10 -0400
Received: by bwz15 with SMTP id 15so4142238bwz.19
        for <linux-media@vger.kernel.org>; Sun, 01 May 2011 11:32:09 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 1 May 2011 20:32:07 +0200
Message-ID: <BANLkTikacJjL+WR74Txhta1nDhEgxm6COA@mail.gmail.com>
Subject: CAM tried to send a buffer larger than the ecount size
From: Pallai Roland <pallair@magex.hu>
To: linux-media@vger.kernel.org
Cc: mldvb@mortal-soul.de
Content-Type: multipart/mixed; boundary=485b3970d4a2d6689104a23b1f79
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--485b3970d4a2d6689104a23b1f79
Content-Type: text/plain; charset=ISO-8859-1

Hi,

On this week I bought a KNC1 clone card with CI to watch cable TV on
my desktop with Kaffeine and the cable provider supplied a Conax
TechniCrypt CX CAM with the subscriber card. I built Kaffeine with
xine-lib-1.2 with VDPAU support so I can watch HD with really low CPU
usage, woah! ;)

For a time everything was fine until I noticed the CAM sometimes
"freezes" on channel switching with the following kernel message:
 dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size
 dvb_ca adapter 0: DVB CAM link initialisation failed :(


I did some debugging with systemtap and found 2 problems:
1. dvb_ca_en50221_write_data sometimes got a STATUSREG_WE status after
the writeout
2. recovery from slot_state:DVB_CA_SLOTSTATE_LINKINIT doesn't work
because dvb_ca_en50221_link_init expects CAM buffer size in 2 bytes
but got 6

On channel switching, there's 2 "big" writes in a bunch. In every
examined case only the second failed and doesn't depend on the size of
bytes_write. dvb_ca_en50221_io_write called from the context of
Kaffeine with valid data, I didn't found race condition, tried to play
with timing in ciintf_write_cam_control@budget-av.c but no success, so
I find workaround:

I found if I replay the write, the next try will successed after
!(status & (STATUSREG_DA | STATUSREG_RE') becomes true again.

A typical error (logged by systemtap) is:
[channel switching]
1. dvb_ca_en50221_write_data bytes_write:0x54 by kaffeine returns OK
2. 2nd dvb_ca_en50221_write_data 0x54 by kaffeine returns -EAGAIN
3. 3rd dvb_ca_en50221_write_data 0x54 by kaffeine
 ciintf_read_cam_control returns 0x82 (STATUSREG_DA | STATUSREG_WE)
 so dvb_ca_en50221_write_data returns -EIO and the LINKINIT fails

My first workaround is return -EAGAIN instead of -EIO in
dvb_ca_en50221_write_data:
[channel switching]
1. dvb_ca_en50221_write_data bytes_write:0x54 by kaffeine returns OK
2. 2nd dvb_ca_en50221_write_data 0x54 by kaffeine returns -EAGAIN
3. 3rd dvb_ca_en50221_write_data 0x54 by kaffeine
  ciintf_read_cam_control returns 0x82
  dvb_ca_en50221_write_data returns -EAGAIN
    thread wakeup, ciintf_read_cam_control called from the thread returns 0x82
    dvb_ca_en50221_io_write calls dvb_ca_en50221_write_data for 10-20
times in a loop cause CTRLIF_STATUS:0x02
    CTRLIF_STATUS becomes 0x80, the thread wakes up and do a read again
    dvb_ca_en50221_write_data got CTRLIF_STATUS:0x40 and the replayed write OK

So the workaround perfect but the root cause is unknown for me. I'm
ready to do more debugging, but I have no idea what should I try next.
Can you help?

(I've no CI/CAM experience and don't have too much time for heavy
interface documentations.)


Related reports:
http://linuxtv.org/pipermail/linux-dvb/2008-August/027764.html
http://www.spinics.net/lists/linux-media/msg19295.html

System info:
Athlon 4850e CPU
Fedora 14, kernel 2.6.35.12-90.fc14.x86_64

DVB card info:
Mystique CaBiX-C2 + Mystique View CI

CAM info (gnutv -cammenu):
1/
CAM Application type: 01
CAM Application manufacturer: cafe
CAM Manufacturer code: babe
CAM Menu string: Conax Conditional Access
7/
1. Software version: CNX-ORDGRC-2.5.10m2
2. Hardware version: 2.2.1
4. Interface version: 0x40
6. Number of sessions: 5
8. CA_SYS_ID: 0x0b00
9. CIM Build Date : Aug  6 2010


--
 Roland Pallai

--485b3970d4a2d6689104a23b1f79
Content-Type: application/octet-stream; name="budget-av.stap"
Content-Disposition: attachment; filename="budget-av.stap"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gn6b60970

IyEvdXNyL2Jpbi9zdGFwIC12CgovKgpwcm9iZSBtb2R1bGUoIipkdmIqIikuZnVuY3Rpb24oImR2
Yl9jYV9lbjUwMjIxX3JlYWRfZGF0YSIpIHsKICAgIHByaW50ZigiIT5kdmJfY2FfZW41MDIyMV9y
ZWFkX2RhdGEgJXUgYnkgJXM6JWRcbiIsICRlY291bnQsIGV4ZWNuYW1lKCksIHBpZCgpKTsKfQpw
cm9iZSBtb2R1bGUoIipkdmIqIikuZnVuY3Rpb24oImR2Yl9jYV9lbjUwMjIxX3JlYWRfZGF0YSIp
LnJldHVybiB7CiAgICBwcmludGYoIiE8ZHZiX2NhX2VuNTAyMjFfcmVhZF9kYXRhICV4XG4iLCAk
cmV0dXJuKTsKfQoqLwoKcHJvYmUgbW9kdWxlKCIqZHZiKiIpLmZ1bmN0aW9uKCJkdmJfY2FfZW41
MDIyMV93cml0ZV9kYXRhIikgewogICAgcHJpbnRmKCIhPmR2Yl9jYV9lbjUwMjIxX3dyaXRlX2Rh
dGEgMHgleCBieSAlczolZFxuIiwgJGJ5dGVzX3dyaXRlLCBleGVjbmFtZSgpLCBwaWQoKSk7Cn0K
cHJvYmUgbW9kdWxlKCIqZHZiKiIpLmZ1bmN0aW9uKCJkdmJfY2FfZW41MDIyMV93cml0ZV9kYXRh
IikucmV0dXJuIHsKICAgIC8vIEByZXR1cm4gTnVtYmVyIG9mIGJ5dGVzIHdyaXR0ZW4sIG9yIDwg
MCBvbiBlcnJvci4KICAgIGlmICgkcmV0dXJuIDwgMCkKCXByaW50ZigiISEhPGR2Yl9jYV9lbjUw
MjIxX3dyaXRlX2RhdGEgMHgleFxuIiwgJHJldHVybik7CiAgICBlbHNlCglwcmludGYoIiE8ZHZi
X2NhX2VuNTAyMjFfd3JpdGVfZGF0YSAweCV4XG4iLCAkcmV0dXJuKTsKfQoKcHJvYmUgbW9kdWxl
KCIqZHZiKiIpLmZ1bmN0aW9uKCJkdmJfY2FfZW41MDIyMV9saW5rX2luaXQiKSB7CiAgICBwcmlu
dGYoIiE+ZHZiX2NhX2VuNTAyMjFfbGlua19pbml0IGJ5ICVzOiVkXG4iLCBleGVjbmFtZSgpLCBw
aWQoKSk7Cn0KLypwcm9iZSBtb2R1bGUoIipkdmIqIikuZnVuY3Rpb24oImR2Yl9jYV9lbjUwMjIx
X2xpbmtfaW5pdCIpLnJldHVybiB7CiAgICBwcmludGYoIiE8ZHZiX2NhX2VuNTAyMjFfbGlua19p
bml0ICV4XG4iLCAkcmV0dXJuKTsKfSovCgpwcm9iZSBtb2R1bGUoIipkdmIqIikuZnVuY3Rpb24o
ImR2Yl9jYV9lbjUwMjIxX3dhaXRfaWZfc3RhdHVzIikgewogICAgcHJpbnRmKCIhPmR2Yl9jYV9l
bjUwMjIxX3dhaXRfaWZfc3RhdHVzXG4iKQp9CnByb2JlIG1vZHVsZSgiKmR2YioiKS5mdW5jdGlv
bigiZHZiX2NhX2VuNTAyMjFfd2FpdF9pZl9zdGF0dXMiKS5yZXR1cm4gewogICAgcHJpbnRmKCIh
PmR2Yl9jYV9lbjUwMjIxX3dhaXRfaWZfc3RhdHVzICV4XG4iLCAkcmV0dXJuKQp9Cgpwcm9iZSBt
b2R1bGUoIipidWRnZXQqIikuZnVuY3Rpb24oImNpaW50Zl9zbG90X3Jlc2V0IikgewogICAgcHJp
bnRmKCIhISFjaWludGZfc2xvdF9yZXNldFxuIikKfQpwcm9iZSBtb2R1bGUoIipidWRnZXQqIiku
ZnVuY3Rpb24oImNpaW50Zl9zbG90X3NodXRkb3duIikgewogICAgcHJpbnRmKCIhISFjaWludGZf
c2xvdF9zaHV0ZG93blxuIikKfQpwcm9iZSBtb2R1bGUoIipidWRnZXQqIikuZnVuY3Rpb24oImNp
aW50Zl9zbG90X3RzX2VuYWJsZSIpIHsKICAgIHByaW50ZigiISEhY2lpbnRmX3Nsb3RfdHNfZW5h
YmxlXG4iKQp9Ci8qCnByb2JlIG1vZHVsZSgiKmJ1ZGdldCoiKS5mdW5jdGlvbigiY2lpbnRmX3Jl
YWRfYXR0cmlidXRlX21lbSIpIHsKICAgIHByaW50ZigiISEhY2lpbnRmX3JlYWRfYXR0cmlidXRl
X21lbVxuIikKfQpwcm9iZSBtb2R1bGUoIipidWRnZXQqIikuZnVuY3Rpb24oImNpaW50Zl93cml0
ZV9hdHRyaWJ1dGVfbWVtIikgewogICAgcHJpbnRmKCIhISFjaWludGZfd3JpdGVfYXR0cmlidXRl
X21lbVxuIikKfQoqLwoKLypwcm9iZSBtb2R1bGUoIipidWRnZXQqIikuZnVuY3Rpb24oImNpaW50
Zl9yZWFkX2NhbV9jb250cm9sIikgewogICAgcHJpbnRmKCIgPmNpaW50Zl9yZWFkX2NhbV9jb250
cm9sIDB4JXhcbiIsICRhZGRyZXNzKQp9Ki8KcHJvYmUgbW9kdWxlKCIqYnVkZ2V0KiIpLmZ1bmN0
aW9uKCJjaWludGZfcmVhZF9jYW1fY29udHJvbCIpLnJldHVybiB7CiAgICBpZiAoJHJldHVybiAm
IDB4ODAgJiYgJHJldHVybiAmIDMpIHsKCXByaW50ZigiICEhIWNpaW50Zl9yZWFkX2NhbV9jb250
cm9sIDB4JXhcbiIsICRyZXR1cm4pCiAgICB9IGVsc2UgewoJLy9wcmludGYoIiA8Y2lpbnRmX3Jl
YWRfY2FtX2NvbnRyb2wgMHgleFxuIiwgJHJldHVybikKICAgIH0KfQoKLypwcm9iZSBtb2R1bGUo
IipidWRnZXQqIikuZnVuY3Rpb24oImNpaW50Zl93cml0ZV9jYW1fY29udHJvbCIpIHsKICAgIHBy
aW50ZigiID5jaWludGZfd3JpdGVfY2FtX2NvbnRyb2wgMHgleDogMHgleFxuIiwgJGFkZHJlc3Ms
ICR2YWx1ZSkKfQpwcm9iZSBtb2R1bGUoIipidWRnZXQqIikuZnVuY3Rpb24oImNpaW50Zl93cml0
ZV9jYW1fY29udHJvbCIpLnJldHVybiB7CiAgICBwcmludGYoIiA8Y2lpbnRmX3dyaXRlX2NhbV9j
b250cm9sIDB4JXhcbiIsICRyZXR1cm4pCn0qLwoKLyoKcHJvYmUgbW9kdWxlKCIqYnVkZ2V0KiIp
LmZ1bmN0aW9uKCJjaWludGZfcG9sbF9zbG90X3N0YXR1cyIpIHsKICAgIHByaW50ZigiPmNpaW50
Zl9wb2xsX3Nsb3Rfc3RhdHVzXG4iKQp9CnByb2JlIG1vZHVsZSgiKmJ1ZGdldCoiKS5mdW5jdGlv
bigiY2lpbnRmX3BvbGxfc2xvdF9zdGF0dXMiKS5yZXR1cm4gewogICAgcHJpbnRmKCI8Y2lpbnRm
X3BvbGxfc2xvdF9zdGF0dXNcbiIpCn0KKi8K
--485b3970d4a2d6689104a23b1f79--
