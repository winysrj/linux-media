Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4348 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2FEW1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2012 18:27:37 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id q55MRXxd025183
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 6 Jun 2012 00:27:34 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 6D3541C320041
	for <linux-media@vger.kernel.org>; Wed,  6 Jun 2012 00:27:31 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] bw-qcam driver update
Date: Wed, 6 Jun 2012 00:27:32 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_UfozPHG/IGb1P5b"
Message-Id: <201206060027.32616.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_UfozPHG/IGb1P5b
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mauro,

This patch fixes various driver issues that came up when I tested my Connectix
B&W parallel port webcam.

Just for fun I've attached a snapshot of the webcam output: it's the best quality
mode of 6 bits per pixel and 320x240, running at less than 1 fps :-)

Tested both on a big endian and a little endian system as well!

The big-endian test actually uncovered a bug in libv4lconvert, so it was useful for
that if nothing else...

Regards,

	Hans

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24 09:27:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git qcam

for you to fetch changes up to 29a11f01cae8c0e72075bb4e2041d9881776ebb9:

  bw-qcam: driver and pixfmt documentation fixes. (2012-06-06 00:15:19 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      bw-qcam: driver and pixfmt documentation fixes.

 Documentation/DocBook/media/v4l/pixfmt.xml |    4 ++--
 drivers/media/video/bw-qcam.c              |   39 +++++++++++++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 8 deletions(-)

--Boundary-00=_UfozPHG/IGb1P5b
Content-Type: image/jpeg;
  name="snapshot.jpg"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="snapshot.jpg"

/9j/4AAQSkZJRgABAQEAZQBlAAD/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEP
ERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4e
Hh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCAEcAVYDASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD6Door
L1fW4tNuBbtatM7IHBEu3qSMY2n065qCzUorkbbxNfeQvnraNJt+by1IGe/G4kCpP+EnuGYFY4Nu
TkFWp2Fc6qiubi8QXLDlITz1CN+Pel/4SCXzNgWJjgH7pH9aLBc6OisVNYmYAlIwO5wf05q1DqIZ
v3hVBjPQkn8KLBc0KKqx3TsGynP8NTCQmONg0YLNggn/ADiiwXJKKsyQRQwLLPPGob7oVgSfw7U6
1gtpEJaYseo8vn8/T60WC5Uoq/DZRzSCKMyb88kfMAPyFWX0mAbCJy4PB2HcB+OMCiwXMeittNLs
s/PLJ1xgOM/yrH8ZodH8OXWo2WJJoVyFkOV/HGP50WC4yivGx8VtexlrPTAOf+Wb/wDxdSQ/FHX3
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

--Boundary-00=_UfozPHG/IGb1P5b--
