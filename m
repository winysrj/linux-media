Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0JWASL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 20:18:11 -0400
Message-ID: <4CC229BC.90000@redhat.com>
Date: Fri, 22 Oct 2010 22:18:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Subject: Re: [PATCH 7/8] v4l: Add EBUSY error description for VIDIOC_STREAMON
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com> <1283756030-28634-8-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1283756030-28634-8-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-09-2010 03:53, Marek Szyprowski escreveu:
> From: Pawel Osciak <p.osciak@samsung.com>
> 
> VIDIOC_STREAMON should return EBUSY if streaming is already active.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  Documentation/DocBook/v4l/vidioc-streamon.xml |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml b/Documentation/DocBook/v4l/vidioc-streamon.xml
> index e42bff1..fdbd8d8 100644
> --- a/Documentation/DocBook/v4l/vidioc-streamon.xml
> +++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
> @@ -93,6 +93,13 @@ synchronize with other events.</para>
>  been allocated (memory mapping) or enqueued (output) yet.</para>
>  	</listitem>
>        </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EBUSY</errorcode></term>
> +	<listitem>
> +	  <para><constant>VIDIOC_STREAMON</constant> called, but
> +	  streaming I/O already active.</para>
> +	</listitem>
> +      </varlistentry>
>      </variablelist>
>    </refsect1>
>  </refentry>

I'm in doubt about this patch. I don't see any problem on just return 0 if
stream is active.

Actually, I think that this patch may break some applications, as there are
some cases where stream may start even without streamon (like via read() method).

Cheers,
Mauro
