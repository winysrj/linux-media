Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51350 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab0ETE2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 00:28:03 -0400
Received: by fxm10 with SMTP id 10so3081490fxm.19
        for <linux-media@vger.kernel.org>; Wed, 19 May 2010 21:28:00 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 May 2010 07:28:00 +0300
Message-ID: <AANLkTin5w5l-v4MzMa05MaCjkq704RIGAmmr12JsE6eV@mail.gmail.com>
Subject: full TS in Linux: known issue or new one?
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: linux-media@vger.kernel.org
Cc: repplinger@motama.com
Content-Type: multipart/mixed; boundary=0015174c1cfceca1f50486feffcb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015174c1cfceca1f50486feffcb
Content-Type: text/plain; charset=ISO-8859-1

hello All,

the issue in question is that in case full TS is captured immediately
after lock ( without some delay ) then garbage data ( that don't
belong to the TS ) are introduced in the stream. initially Michael
Repplinger noticed the problem and told me about it. also, he made
test script ( 'run_szap-s2_adapter0_record_dvbsnoop.sh' ) for
reproducing the problem easily ( you can find it in the attachment, i
made some very small changed to it compared to the original script).

so, basically, the test script 'szap-s2' to first transponder in your
'channel.conf' file, use 'dvbsnoop' to dump the full TS from that
transponder to a file for 30 seconds, then 'szap-s2' to second
transponder in your 'channel.conf' file, use 'dvbsnoop' again to dump
the full TS to another file for 30 seconds and repeats this in endless
loop. if there is no delay ( 'sleep 0' ) or delay is less than 5
seconds ( at least on my setup those are delays i measured ) between
executing 'szap-s2' and 'dvbsnoop' then captured stream contains some
additional data that don't belong there, i.e. garbage and you can
confirmed it with any TS analyzer tool or just use the attached
'test_file_with_dvbsnoop.sh' that Michael Repplinger prepared.

i've already tested about 10 DVB devices from different manufacturers
using completely different chips and PCI or PCIe interface and even
USB interface, just for completeness here is what i've already tested:

- Philips/NXP SAA7146 bridge driver
- B2C2 Flexcop IIb PCI bridge driver (put in full TS mode with
'options b2c2_flexcop_pci enable_pid_filtering=0')
- Booktree bt8xx bridge driver
- Conexant cx88 bridge driver
- Conexant cx23885 bridge driver
- all USB DVB devices i have (all of them use Cypress USB controller)

and with all of the above i can reproduce the problem using
'run_szap-s2_adapter0_record_dvbsnoop.sh' script. however, it seems
SAA7146 is somehow better than the others, because sometimes it works
good, i.e. captures correct data even without any delay between
executing 'szap-s2' and 'dvbsnoop'.

so, any ideas, please, either for what could be the root cause for the
problem or for acceptable workaround? it seems to me at least at the
moment it's a general problem with Linux DVB, but maybe it's known
issue and someone knows more about it.

many thanks,
konstantin

--0015174c1cfceca1f50486feffcb
Content-Type: application/x-sh; name="test_file_with_dvbsnoop.sh"
Content-Disposition: attachment; filename="test_file_with_dvbsnoop.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9f27dx30

IyEvYmluL2Jhc2gKCiMgaG93IHRvIGNhbGwgdGhpcyBzY3JpcHQ6IC4vdGVzdF9maWxlX3dpdGhf
ZHZic25vb3Auc2ggPGZpbGU+CgpGSUxFPSQxCkxPR19GSUxFPSIkRklMRSIubG9nClRNUF9GSUxF
PSIkRklMRSIudG1wClRNUF9GSUxFMj0iJEZJTEUiMi50bXAKCmVjaG8gJEZJTEUgPiAkTE9HX0ZJ
TEUKCgplY2hvICJBbmFseXplIGZpbGUgJDEgLiBUaGlzIGNvdWxkIHRha2Ugc29tZSB0aW1lIC4u
LiIgCmR2YnNub29wIC1ub2hleGR1bXBidWZmZXIgLXMgdHMgLXBoIDAgLXBkIDMgLWlmICQxIHwg
Z3JlcCAiUElEOiIgfCBncmVwIC12ICJUUy1QYWNrZXQiID4gIiRUTVBfRklMRSIgMj4mMQplY2hv
ICJGaW5pc2hlZCIgCgplY2hvICJGb3VuZCBQSURzOiIgPj4gJExPR19GSUxFCmNhdCAiJFRNUF9G
SUxFIiB8IHNvcnQgfCB1bmlxID4gIiRUTVBfRklMRTIiCmNhdCAiJFRNUF9GSUxFMiIgPj4gJExP
R19GSUxFCmVjaG8gIlN1bToiID4+ICRMT0dfRklMRQpjYXQgIiRUTVBfRklMRTIiIHwgd2MgLWwg
Pj4gJExPR19GSUxFCnJtICIkVE1QX0ZJTEUiCnJtICIkVE1QX0ZJTEUyIgoKZWNobyA+PiAkTE9H
X0ZJTEUKCmNhdCAkTE9HX0ZJTEUK
--0015174c1cfceca1f50486feffcb
Content-Type: application/x-sh;
	name="run_szap-s2_adapter0_record_dvbsnoop.sh"
Content-Disposition: attachment;
	filename="run_szap-s2_adapter0_record_dvbsnoop.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9f27i9d1

IyEvYmluL2Jhc2gKCkRBVEU9YGRhdGUgIislWSVtJWQiYApMT0dGSUxFPXJlY29yZF9hZGFwdGVy
MF9mdWxsX3RyYW5zcG9uZGVyXyIkREFURSIubG9nCgpraWxsYWxsIC05IGR2YnNub29wCmtpbGxh
bGwgLTkgc3phcC1zMgoKZWNobyA+ICRMT0dGSUxFCgpmb3IgKCg7OykpCmRvCiAgICBUSU1FU1RB
TVA9JERBVEUiXyJgZGF0ZSAiKyVIJU0lUyJgCiAgICBlY2hvICJDaGFubmVsIDEiID4+ICRMT0dG
SUxFCiAgICBlY2hvICJyZWNvcmRfYWRhcHRlcjBfY2hhbm5lbDFfZnVsbF90cmFuc3BvbmRlcl8i
JFRJTUVTVEFNUCIudHMiID4+ICRMT0dGSUxFCiAgICAoLi9zemFwLXMyIC1jIGNoYW5uZWwuY29u
ZiAtSCAtUyAwIC1hIDAgLW4gMSAtciAtcCA+PiAkTE9HRklMRSAyPiYxKSAmCiAgICBzbGVlcCAw
CiAgICAoZHZic25vb3AgLWIgLXMgdHMgLXRzcmF3ID4gcmVjb3JkX2FkYXB0ZXIwX2NoYW5uZWwx
X2Z1bGxfdHJhbnNwb25kZXJfIiRUSU1FU1RBTVAiLnRzKSAmCiAgICAoc2xlZXAgMzAgJiYga2ls
bGFsbCAtOSBkdmJzbm9vcCAmJiBraWxsYWxsIC05IHN6YXAtczIpCiAgICBlY2hvID4+ICRMT0dG
SUxFCiAgICBzbGVlcCAxCgogICAgVElNRVNUQU1QPSREQVRFIl8iYGRhdGUgIislSCVNJVMiYAog
ICAgZWNobyAiQ2hhbm5lbCAyIiA+PiAkTE9HRklMRQogICAgZWNobyAicmVjb3JkX2FkYXB0ZXIw
X2NoYW5uZWwyX2Z1bGxfdHJhbnNwb25kZXJfIiRUSU1FU1RBTVAiLnRzIiA+PiAkTE9HRklMRQog
ICAgKC4vc3phcC1zMiAtYyBjaGFubmVsLmNvbmYgLUggLVMgMCAtYSAwIC1uIDIgLXIgIC1wID4+
ICRMT0dGSUxFIDI+JjEpICYKICAgIHNsZWVwIDAKICAgIChkdmJzbm9vcCAtYiAtcyB0cyAtdHNy
YXcgPiByZWNvcmRfYWRhcHRlcjBfY2hhbm5lbDJfZnVsbF90cmFuc3BvbmRlcl8iJFRJTUVTVEFN
UCIudHMpICYKICAgIChzbGVlcCAzMCAmJiBraWxsYWxsIC05IGR2YnNub29wICYmIGtpbGxhbGwg
LTkgc3phcC1zMikKICAgIGVjaG8gPj4gJExPR0ZJTEUKICAgIHNsZWVwIDEKZG9uZQo=
--0015174c1cfceca1f50486feffcb--
