Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58989 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791Ab2DWO1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 10:27:55 -0400
Received: by qcmt36 with SMTP id t36so7042143qcm.15
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 07:27:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANMsd01DZ=Uvvv9gXHCMro_vT17yvd29y113Y9_WwySfkwqV0Q@mail.gmail.com>
References: <CANMsd01DZ=Uvvv9gXHCMro_vT17yvd29y113Y9_WwySfkwqV0Q@mail.gmail.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 23 Apr 2012 09:27:33 -0500
Message-ID: <CAKnK67Qe_MjoTSTz+o8WPQg413tt7zFjf+8o3YmVURKCOiK9mg@mail.gmail.com>
Subject: Re: ics port for camera hal?
To: Ryan <ryanphilips19@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ryan

On Sun, Apr 22, 2012 at 6:05 AM, Ryan <ryanphilips19@googlemail.com> wrote:
> Hi,
>
> Is there an V4L Port in the camera hal implementations on android ice
> cream sandwich which makes use
> of panda v4l camera drivers.

Me and a couple of colleagues in TI are working on this at the moment,
and we hope to have
something useful very soon.

What we have achieved so far is a PandaBoard bootign ICS with support
for UVC cameras, so that
Camera Application can start preview (just that for the moment, plenty
of things to take care of yet..)

But you can check this out here of you are interested on it:

http://omappedia.org/wiki/Building_L27.IS.2.M1_for_PandaBoard,_with_USB_camera_support

Regards,
Sergio
>
> Thanks & Regards,
> Ryan
