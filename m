Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58071 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbZDFLvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 07:51:52 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Mon, 6 Apr 2009 17:21:14 +0530
Subject: RE: [PATCH 1/3] Documentation for new V4L2 CIDs added.
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02FB102FD5@dbde02.ent.ti.com>
In-Reply-To: <200903301352.58079.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Please find my comments inline.

Regards,
Hardik 

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Monday, March 30, 2009 5:23 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav, Brijesh R;
> Hiremath, Vaibhav
> Subject: Re: [PATCH 1/3] Documentation for new V4L2 CIDs added.
> 
> Hi Hardik,
> 
> OK, so it took a little longer than a week. So sue me :-)
> 
> Typo: chorma -> chroma
[Shah, Hardik] Done in next post
> 
> > +images will be replaced by the video images.  Exactly
> > +opposite of <constant>V4L2_FBUF_CAP_CHROMAKEY</constant></entry>
> 
> Hmm. This is a bit obscure. CAP_CHROMAKEY means that framebuffer pixels with
> the chromakey color are replaced by video pixels. CAP_SRC_CHROMAKEY means
> that video pixels with the chromakey color are replaced by the framebuffer
> pixels. At least the way I read it this is the opposite of what you wrote.
> 
> It pays to be very precise here since it can get confusing very quickly.
[Shah, Hardik] Done in next post
> 
> > +	  </row>
> >  	</tbody>
> >        </tgroup>
> >      </table>
> > @@ -411,6 +418,18 @@ images, but with an inverted alpha value. The blend
> function is:
> >  output = framebuffer pixel * (1 - alpha) + video pixel * alpha. The
> >  actual alpha depth depends on the framebuffer pixel format.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_FBUF_FLAG_SRC_CHROMAKEY</constant></entry>
> > +	    <entry>0x0040</entry>
> > +	    <entry>Use chroma-keying. The chroma-key color is
> 
> Write: 'Use source chroma-keying.' to prevent confusion with
> V4L2_FBUF_FLAG_CHROMAKEY.
> 
[Shah, Hardik] Done in next post
> > +determined by the <structfield>chromakey</structfield> field of
> > +&v4l2-window; and negotiated with the &VIDIOC-S-FMT; ioctl, see <xref
> > +linkend="overlay"> and <xref linkend="osd">.
> > +Since any one of the chorma keying can be active at a time as both
> 
> Typo: chorma -> chroma
[Shah, Hardik] Done in next post
> 
> > +of them are exactly opposite same <structfield>chromakey</structfield>
> 
> Typo: 'opposite same' -> 'opposite the same'
[Shah, Hardik] Done in next post
> 
> > +field of &v4l2-window; can be used to set the chroma key for source
> > +keying also.</entry>
> > +	  </row>
> >  	</tbody>
> >        </tgroup>
> >      </table>
> > --
> > 1.5.6
> 
> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

