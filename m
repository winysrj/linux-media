Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:36222 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3HVKmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:42:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 PATCH 09/10] DocBook: document the new v4l2 matrix ioctls.
Date: Thu, 22 Aug 2013 12:42:34 +0200
Cc: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sylvester.nawrocki@gmail.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
References: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl> <5215B600.8000009@xs4all.nl> <2389202.KPmZT6iCB5@avalon>
In-Reply-To: <2389202.KPmZT6iCB5@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221242.34086.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 22 August 2013 12:34:56 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 22 August 2013 08:56:00 Hans Verkuil wrote:
> > On 08/21/2013 11:58 PM, Laurent Pinchart wrote:
> > > On Monday 12 August 2013 12:58:32 Hans Verkuil wrote:
> > >> From: Hans Verkuil <hans.verkuil@cisco.com>
> > >> 
> > >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >> ---
> > >> 
> > >>  Documentation/DocBook/media/v4l/v4l2.xml           |   2 +
> > >>  .../DocBook/media/v4l/vidioc-g-matrix.xml          | 115 +++++++++++++
> > >>  .../DocBook/media/v4l/vidioc-query-matrix.xml      | 178 +++++++++++++++
> > >>  3 files changed, 295 insertions(+)
> > >>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-matrix.xml
> > >>  create mode 100644
> > >>  Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
> > > 
> > > [snip]
> > > 
> > >> diff --git a/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
> > >> b/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml new file mode
> > >> 100644
> > >> index 0000000..c2845c7
> > >> --- /dev/null
> > >> +++ b/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
> 
> [snip]
> 
> > >> +    <table pgwide="1" frame="none" id="v4l2-matrix-type">
> > >> +      <title>Matrix Types</title>
> > >> +      <tgroup cols="2" align="left">
> > >> +	<colspec colwidth="30*" />
> > >> +	<colspec colwidth="55*" />
> > >> +	<thead>
> > >> +	  <row>
> > >> +	    <entry>Type</entry>
> > >> +	    <entry>Description</entry>
> > >> +	  </row>
> > >> +	</thead>
> > >> +	<tbody valign="top">
> > >> +	  <row>
> > >> +	    <entry><constant>V4L2_MATRIX_T_MD_REGION</constant></entry>
> > >> +	    <entry>Hardware motion detection often divides the image into
> > >> several
> > >> +	    regions, and each region can have its own motion detection
> > >> thresholds.
> > >> +	    This matrix assigns a region number to each element. Each element
> > >> is
> > >> a __u8.
> > >> +	    Generally each element refers to a block of pixels in the image.
> > > 
> > > From the description I have trouble understanding what the matrix type is
> > > for. Do you think we could make the explanation more detailed ?
> > 
> > How about this:
> > 
> > Hardware motion detection divides the image up into cells. If the image
> > resolution is WxH and the matrix size is COLSxROWS, then each cell is a
> > rectangle of (W/COLS)x(H/ROWS) pixels (approximately as there may be some
> > rounding involved). Depending on the hardware each cell can have its own
> > properties. This matrix type sets the 'region' property which is a __u8.
> > Each region will typically have its own set of motion detection parameters
> > such as a threshold that determines the motion detection sensitivity. By
> > assigning each cell a region you can create regions with lower and regions
> > with higher motion sensitivity.
> 
> That sounds good to me. One more question, however: if the hardware divides 
> the sub-sampled image into regions, how do you configure per-region thresholds 
> ? The V4L2_MATRIX_T_MD_THRESHOLD matrix only configures per-cell thresholds.

That's hardware dependent. The go7007 has four different threshold parameters
per region, so that's a total of 16 controls for all four regions.

If we get more drivers doing motion detection in the future, then some of those
parameters might become standardized, but at the moment I have only one driver
and I don't want to standardize that as long as I don't know if it can be
standardized in the first place.

Regards,

	Hans

> 
> > > > +	    </entry>
> > > > +	  </row>
> > > > +	  <row>
> > > > +	    <entry><constant>V4L2_MATRIX_T_MD_THRESHOLD</constant></entry>
> > > > +	    <entry>Hardware motion detection can assign motion detection
> > > > threshold +	    values to each element of an image. Each element is a
> > > > __u16. +       Generally each element refers to a block of pixels in
> > > > the image.
> > This would be improved as well along the same lines:
> > 
> > Hardware motion detection divides the image up into cells. If the image
> > resolution is WxH and the matrix size is COLSxROWS, then each cell is a
> > rectangle of (W/COLS)x(H/ROWS) pixels (approximately as there may be some
> > rounding involved). Depending on the hardware each cell can have its own
> > motion detection sensitivity threshold. This matrix type sets the motion
> > detection threshold property which is a __u16.
> > > > +	    </entry>
> > > > +	  </row>
> > > > +	</tbody>
> > > > +      </tgroup>
> > > > +    </table>
> > > > +
> > > > +  </refsect1>
> > > > +  <refsect1>
> > > > +    &return-value;
> > > > +  </refsect1>
> > > > +</refentry>
> 
> 
