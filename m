Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3849 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3HVG4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 02:56:25 -0400
Message-ID: <5215B600.8000009@xs4all.nl>
Date: Thu, 22 Aug 2013 08:56:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sylvester.nawrocki@gmail.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 09/10] DocBook: document the new v4l2 matrix ioctls.
References: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl> <1376305113-17128-10-git-send-email-hverkuil@xs4all.nl> <1527473.WFxGOHRo9q@avalon>
In-Reply-To: <1527473.WFxGOHRo9q@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2013 11:58 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Monday 12 August 2013 12:58:32 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  Documentation/DocBook/media/v4l/v4l2.xml           |   2 +
>>  .../DocBook/media/v4l/vidioc-g-matrix.xml          | 115 +++++++++++++
>>  .../DocBook/media/v4l/vidioc-query-matrix.xml      | 178 ++++++++++++++++++
>>  3 files changed, 295 insertions(+)
>>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-matrix.xml
>>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
> 
> [snip]
> 
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
>> b/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml new file mode
>> 100644
>> index 0000000..c2845c7
>> --- /dev/null
>> +++ b/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
>> @@ -0,0 +1,178 @@
>> +<refentry id="vidioc-query-matrix">
>> +  <refmeta>
>> +    <refentrytitle>ioctl VIDIOC_QUERY_MATRIX</refentrytitle>
>> +    &manvol;
>> +  </refmeta>
>> +
>> +  <refnamediv>
>> +    <refname>VIDIOC_QUERY_MATRIX</refname>
>> +    <refpurpose>Query the attributes of a matrix</refpurpose>
>> +  </refnamediv>
>> +
>> +  <refsynopsisdiv>
>> +    <funcsynopsis>
>> +      <funcprototype>
>> +	<funcdef>int <function>ioctl</function></funcdef>
>> +	<paramdef>int <parameter>fd</parameter></paramdef>
>> +	<paramdef>int <parameter>request</parameter></paramdef>
>> +	<paramdef>struct v4l2_query_matrix
>> +*<parameter>argp</parameter></paramdef>
>> +      </funcprototype>
>> +    </funcsynopsis>
>> +  </refsynopsisdiv>
>> +
>> +  <refsect1>
>> +    <title>Arguments</title>
>> +
>> +    <variablelist>
>> +      <varlistentry>
>> +	<term><parameter>fd</parameter></term>
>> +	<listitem>
>> +	  <para>&fd;</para>
>> +	</listitem>
>> +      </varlistentry>
>> +      <varlistentry>
>> +	<term><parameter>request</parameter></term>
>> +	<listitem>
>> +	  <para>VIDIOC_QUERY_MATRIX</para>
>> +	</listitem>
>> +      </varlistentry>
>> +      <varlistentry>
>> +	<term><parameter>argp</parameter></term>
>> +	<listitem>
>> +	  <para></para>
>> +	</listitem>
>> +      </varlistentry>
>> +    </variablelist>
>> +  </refsect1>
>> +
>> +  <refsect1>
>> +    <title>Description</title>
>> +
>> +    <para>Query the attributes of a matrix. The application fills in the
>> +    <structfield>type</structfield> and optionally the
>> <structfield>ref</structfield>
>> +    fields of &v4l2-query-matrix;. All other fields will be returned by the
>> driver.
>> +    </para>
>> +
>> +    <table frame="none" pgwide="1" id="v4l2-query-matrix">
>> +      <title>struct <structname>v4l2_query_matrix</structname></title>
>> +      <tgroup cols="4">
>> +	&cs-str;
>> +	<tbody valign="top">
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>type</structfield></entry>
>> +            <entry></entry>
>> +	    <entry>Type of the matrix, see <xref linkend="v4l2-matrix-type"
>> />.</entry> +	  </row>
>> +	  <row>
>> +	    <entry>union</entry>
>> +	    <entry><structfield>ref</structfield></entry>
>> +            <entry></entry>
>> +	    <entry>This union makes it possible to identify the object owning the
>> +	    matrix. Currently the only defined matrix types are identified
>> through
>> +	    the filehandle used to call the ioctl, so this union isn't used
>> (yet).</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>columns</structfield></entry>
>> +            <entry></entry>
>> +	    <entry>Number of columns in the matrix.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>rows</structfield></entry>
>> +            <entry></entry>
>> +	    <entry>Number of rows in the matrix.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>union</entry>
>> +	    <entry><structfield>elem_min</structfield></entry>
>> +            <entry></entry>
>> +            <entry></entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry></entry>
>> +            <entry>__s64</entry>
>> +	    <entry><structfield>val</structfield></entry>
>> +            <entry>The minimal signed value of each matrix element.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry></entry>
>> +            <entry>__u64</entry>
>> +	    <entry><structfield>uval</structfield></entry>
>> +            <entry>The minimal unsigned value of each matrix
>> element.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>union</entry>
>> +	    <entry><structfield>elem_max</structfield></entry>
>> +            <entry></entry>
>> +            <entry></entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry></entry>
>> +            <entry>__s64</entry>
>> +	    <entry><structfield>val</structfield></entry>
>> +            <entry>The maximal signed value of each matrix element.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry></entry>
>> +            <entry>__u64</entry>
>> +	    <entry><structfield>uval</structfield></entry>
>> +            <entry>The maximal unsigned value of each matrix
>> element.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>elem_size</structfield></entry>
>> +            <entry></entry>
>> +	    <entry>The size in bytes of a single matrix element.
>> +	    The full matrix size will be <structfield>columns</structfield> *
>> +	    <structfield>rows</structfield> *
>> <structfield>elem_size</structfield>.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>reserved</structfield>[12]</entry>
>> +            <entry></entry>
>> +	    <entry>Reserved for future extensions. Drivers must set
>> +	    the array to zero.</entry>
>> +	  </row>
>> +	</tbody>
>> +      </tgroup>
>> +    </table>
>> +
>> +    <table pgwide="1" frame="none" id="v4l2-matrix-type">
>> +      <title>Matrix Types</title>
>> +      <tgroup cols="2" align="left">
>> +	<colspec colwidth="30*" />
>> +	<colspec colwidth="55*" />
>> +	<thead>
>> +	  <row>
>> +	    <entry>Type</entry>
>> +	    <entry>Description</entry>
>> +	  </row>
>> +	</thead>
>> +	<tbody valign="top">
>> +	  <row>
>> +	    <entry><constant>V4L2_MATRIX_T_MD_REGION</constant></entry>
>> +	    <entry>Hardware motion detection often divides the image into several
>> +	    regions, and each region can have its own motion detection
>> thresholds.
>> +	    This matrix assigns a region number to each element. Each element is
>> a __u8.
>> +	    Generally each element refers to a block of pixels in the image.
> 
> From the description I have trouble understanding what the matrix type is for. 
> Do you think we could make the explanation more detailed ?

How about this:

Hardware motion detection divides the image up into cells. If the image resolution
is WxH and the matrix size is COLSxROWS, then each cell is a rectangle of (W/COLS)x(H/ROWS)
pixels (approximately as there may be some rounding involved). Depending on the
hardware each cell can have its own properties. This matrix type sets the 'region'
property which is a __u8. Each region will typically have its own set of motion detection
parameters such as a threshold that determines the motion detection sensitivity. By
assigning each cell a region you can create regions with lower and regions with higher
motion sensitivity. 

> > +	    </entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_MATRIX_T_MD_THRESHOLD</constant></entry>
> > +	    <entry>Hardware motion detection can assign motion detection threshold
> > +	    values to each element of an image. Each element is a __u16.
> > +       Generally each element refers to a block of pixels in the image.

This would be improved as well along the same lines:

Hardware motion detection divides the image up into cells. If the image resolution
is WxH and the matrix size is COLSxROWS, then each cell is a rectangle of (W/COLS)x(H/ROWS)
pixels (approximately as there may be some rounding involved). Depending on the
hardware each cell can have its own motion detection sensitivity threshold. This matrix
type sets the motion detection threshold property which is a __u16.


> > +	    </entry>
> > +	  </row>
> > +	</tbody>
> > +      </tgroup>
> > +    </table>
> > +
> > +  </refsect1>
> > +  <refsect1>
> > +    &return-value;
> > +  </refsect1>
> > +</refentry>

Regards,

	Hans
