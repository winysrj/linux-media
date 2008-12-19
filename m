Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJCQnE6021767
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 07:26:49 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJCQYit031245
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 07:26:35 -0500
Received: by wf-out-1314.google.com with SMTP id 25so941946wfc.6
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 04:26:34 -0800 (PST)
Message-ID: <aec7e5c30812190426ja9252a6k95b626c2ce87a909@mail.gmail.com>
Date: Fri, 19 Dec 2008 21:26:33 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812171938460.8733@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_35819_7128533.1229689593954"
References: <Pine.LNX.4.64.0812171938460.8733@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 3/4] soc-camera: add new bus width and signal polarity
	flags
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

------=_Part_35819_7128533.1229689593954
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Dec 18, 2008 at 3:45 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> In preparation for i.MX31 camera host driver add flags for 4 and 15 bit bus
> widths and for data lines polarity inversion.
>
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---

This is a good plan...

> Careful, soc_camera_bus_param_compatible() is more selective with this
> patch, some configurations might break.

...but you break the SuperH Migo-R board with this patch. You need to
add flags to the Migo-R board code as well to avoid breakage, see the
half-assed attached patch. Thanks to Morimoto-san for pointing out the
breakage.

I wonder if it's a better strategy to break this patch into two parts
- one with the flags only for early merge and another one that handles
the part doing soc_camera_bus_param_compatible(). But maybe you depend
on the latter to probe or attach properly?

Cheers,

/ magnus

------=_Part_35819_7128533.1229689593954
Content-Type: application/octet-stream; name=v4l-degrade-20081219.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fowtag3e0
Content-Disposition: attachment; filename=v4l-degrade-20081219.patch

LS0tIDAwMDcvYXJjaC9zaC9ib2FyZHMvbWFjaC1taWdvci9zZXR1cC5jCisrKyB3b3JrL2FyY2gv
c2gvYm9hcmRzL21hY2gtbWlnb3Ivc2V0dXAuYwkyMDA4LTEyLTE5IDIxOjA4OjU3LjAwMDAwMDAw
MCArMDkwMApAQCAtNDA0LDcgKzQwNCw4IEBAIHN0YXRpYyBzdHJ1Y3Qgc29jX2NhbWVyYV9wbGF0
Zm9ybV9pbmZvIG8KIAkJLmhlaWdodCA9IDI0MCwKIAl9LAogCS5idXNfcGFyYW0gPSAgU09DQU1f
UENMS19TQU1QTEVfUklTSU5HIHwgU09DQU1fSFNZTkNfQUNUSVZFX0hJR0ggfAotCVNPQ0FNX1ZT
WU5DX0FDVElWRV9ISUdIIHwgU09DQU1fTUFTVEVSIHwgU09DQU1fREFUQVdJRFRIXzgsCisJU09D
QU1fVlNZTkNfQUNUSVZFX0hJR0ggfCBTT0NBTV9NQVNURVIgfCBTT0NBTV9EQVRBV0lEVEhfOAor
CXwgU09DQU1fREFUQV9BQ1RJVkVfSElHSCwKIAkucG93ZXIgPSBjYW1lcmFfcG93ZXIsCiAJLnNl
dF9jYXB0dXJlID0gb3Y3NzJ4X3NldF9jYXB0dXJlLAogfTsKQEAgLTQxOSw3ICs0MjAsOCBAQCBz
dGF0aWMgc3RydWN0IHBsYXRmb3JtX2RldmljZSBtaWdvcl9jYW1lCiAKIHN0YXRpYyBzdHJ1Y3Qg
c2hfbW9iaWxlX2NldV9pbmZvIHNoX21vYmlsZV9jZXVfaW5mbyA9IHsKIAkuZmxhZ3MgPSBTT0NB
TV9NQVNURVIgfCBTT0NBTV9EQVRBV0lEVEhfOCB8IFNPQ0FNX1BDTEtfU0FNUExFX1JJU0lORyBc
Ci0JfCBTT0NBTV9IU1lOQ19BQ1RJVkVfSElHSCB8IFNPQ0FNX1ZTWU5DX0FDVElWRV9ISUdILAor
CXwgU09DQU1fSFNZTkNfQUNUSVZFX0hJR0ggfCBTT0NBTV9WU1lOQ19BQ1RJVkVfSElHSCBcCisJ
fCBTT0NBTV9EQVRBX0FDVElWRV9ISUdILAogfTsKIAogc3RhdGljIHN0cnVjdCByZXNvdXJjZSBt
aWdvcl9jZXVfcmVzb3VyY2VzW10gPSB7Cg==
------=_Part_35819_7128533.1229689593954
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_35819_7128533.1229689593954--
