Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48797 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914Ab0JXTuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 15:50:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 7/8] v4l: Add EBUSY error description for VIDIOC_STREAMON
Date: Sun, 24 Oct 2010 21:50:55 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com> <4CC229BC.90000@redhat.com> <AANLkTin_puofnGcxyLbcLCqE8TbX0CUbtHRd-o+CBQt2@mail.gmail.com>
In-Reply-To: <AANLkTin_puofnGcxyLbcLCqE8TbX0CUbtHRd-o+CBQt2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010242150.55591.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 24 October 2010 18:52:09 Pawel Osciak wrote:
> On Fri, Oct 22, 2010 at 17:18, Mauro Carvalho Chehab <mchehab@redhat.com> 
wrote:
> > Em 06-09-2010 03:53, Marek Szyprowski escreveu:
> >> From: Pawel Osciak <p.osciak@samsung.com>
> >> 
> >> VIDIOC_STREAMON should return EBUSY if streaming is already active.
> >> 
> >> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> ---
> >>  Documentation/DocBook/v4l/vidioc-streamon.xml |    7 +++++++
> >>  1 files changed, 7 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml
> >> b/Documentation/DocBook/v4l/vidioc-streamon.xml index e42bff1..fdbd8d8
> >> 100644
> >> --- a/Documentation/DocBook/v4l/vidioc-streamon.xml
> >> +++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
> >> @@ -93,6 +93,13 @@ synchronize with other events.</para>
> >>  been allocated (memory mapping) or enqueued (output) yet.</para>
> >>       </listitem>
> >>        </varlistentry>
> >> +      <varlistentry>
> >> +     <term><errorcode>EBUSY</errorcode></term>
> >> +     <listitem>
> >> +       <para><constant>VIDIOC_STREAMON</constant> called, but
> >> +       streaming I/O already active.</para>
> >> +     </listitem>
> >> +      </varlistentry>
> >>      </variablelist>
> >>    </refsect1>
> >>  </refentry>
> > 
> > I'm in doubt about this patch. I don't see any problem on just return 0
> > if stream is active.
> > 
> > Actually, I think that this patch may break some applications, as there
> > are some cases where stream may start even without streamon (like via
> > read() method).
> 
> A quick grep over the media directory reveals that many drivers
> (including videobuf_streamon) return EBUSY for some cases. This patch
> was not intended to introduce something new to the API. I just wanted
> to document an undocumented return value. How should the EBUSY return
> be interpreted? Or should we get rid of it?

I think the patch makes sense. As you mention many drivers already implement 
this behaviour, so this mostly clarifies the API. Calling VIDIOC_STREAMON on 
an already streaming file handle isn't something applications should do in the 
first place anyway.

-- 
Regards,

Laurent Pinchart
