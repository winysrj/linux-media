Return-path: <mchehab@pedra>
Received: from mx.treblig.org ([80.68.94.177]:49955 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab1DCAYc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 20:24:32 -0400
Date: Sun, 3 Apr 2011 01:24:28 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: pawel@osciak.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	zyprowski@samsung.com
Subject: Re: vb2_plane 'mapped' signed bit field
Message-ID: <20110403002428.GD3062@gallifrey>
References: <20110403001856.GC3062@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403001856.GC3062@gallifrey>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


(Originally sent to Pawel's Samsung address that bounced)

* Dr. David Alan Gilbert (linux@treblig.org) wrote:
> Hi Pawel,
>   'sparse' spotted that vb2_plane's mapped field is a signed
> bitfield:
> 
> include/media/videobuf2-core.h:78:41 1 bit signed int
> 
> struct vb2_plane {
>        void                    *mem_priv;
>        int                     mapped:1;
> };
> 
> that probably should be an unsigned int (I can see code that assigns
> 1 to it that just won't fit).
> 
> (Introduced by e23ccc0ad9258634e6d52cedf473b35dc34416c7 , spotted in
> 2.6.39-rc1 )
> 
> Dave
> -- 
>  -----Open up your eyes, open up your mind, open up your code -------   
> / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
> \ gro.gilbert @ treblig.org |                               | In Hex /
>  \ _________________________|_____ http://www.treblig.org   |_______/
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
