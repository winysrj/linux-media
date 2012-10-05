Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3168 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2JEIpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 04:45:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv9 17/25] Documentation: media: description of DMABUF exporting in V4L2
Date: Fri, 5 Oct 2012 10:44:22 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com,
	linux-doc@vger.kernel.org
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <1349188056-4886-18-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349188056-4886-18-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210051044.23099.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More stylistic comments and a suggestion for re-ordering the fields in the expbuf struct.

On Tue October 2 2012 16:27:28 Tomasz Stanislawski wrote:
> This patch adds description and usage examples for exporting
> DMABUF file descriptor in V4L2.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: linux-doc@vger.kernel.org
> ---
>  Documentation/DocBook/media/v4l/compat.xml        |    3 +
>  Documentation/DocBook/media/v4l/io.xml            |    3 +
>  Documentation/DocBook/media/v4l/v4l2.xml          |    1 +
>  Documentation/DocBook/media/v4l/vidioc-expbuf.xml |  212 +++++++++++++++++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index a46f95b..f0512aa 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2625,6 +2625,9 @@ ioctls.</para>
>  	  <para>Importing DMABUF file descriptors as a new IO method described
>  	  in <xref linkend="dmabuf" />.</para>
>          </listitem>
> +        <listitem>
> +	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
> +        </listitem>
>        </itemizedlist>
>      </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 5b58657..476f448 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -488,6 +488,9 @@ DMA buffer from userspace using a file descriptor previously exported for a
>  different or the same device (known as the importer role), or both. This
>  section describes the DMABUF importer role API in V4L2.</para>
>  
> +    <para>Refer to <link linked="vidioc-expbuf"> DMABUF exporting </link> for
> +details about exporting a V4L2 buffers as DMABUF file descriptors.</para>

"exporting a" -> "exporting"

> +
>  <para>Input and output devices support the streaming I/O method when the
>  <constant>V4L2_CAP_STREAMING</constant> flag in the
>  <structfield>capabilities</structfield> field of &v4l2-capability; returned by
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index eee6908..d8c2597 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -543,6 +543,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-enuminput;
>      &sub-enumoutput;
>      &sub-enumstd;
> +    &sub-expbuf;
>      &sub-g-audio;
>      &sub-g-audioout;
>      &sub-g-crop;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
> new file mode 100644
> index 0000000..bf28e7d
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
> @@ -0,0 +1,212 @@
> +<refentry id="vidioc-expbuf">
> +
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_EXPBUF</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_EXPBUF</refname>
> +    <refpurpose>Export a buffer as a DMABUF file descriptor.</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_exportbuffer *<parameter>argp</parameter></paramdef>
> +      </funcprototype>
> +    </funcsynopsis>
> +  </refsynopsisdiv>
> +
> +  <refsect1>
> +    <title>Arguments</title>
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><parameter>fd</parameter></term>
> +	<listitem>
> +	  <para>&fd;</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>request</parameter></term>
> +	<listitem>
> +	  <para>VIDIOC_EXPBUF</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>argp</parameter></term>
> +	<listitem>
> +	  <para></para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <note>
> +      <title>Experimental</title>
> +      <para>This is an <link linkend="experimental"> experimental </link>
> +      interface and may change in the future.</para>
> +    </note>
> +
> +<para>This ioctl is an extension to the <link linkend="mmap">memory
> +mapping</link> I/O method therefore it is available only for

"method therefore" -> "method, therefore"

> +<constant>V4L2_MEMORY_MMAP</constant> buffers.  It can be used to export a
> +buffer as a DMABUF file at any time after buffers have been allocated with the
> +&VIDIOC-REQBUFS; ioctl.</para>
> +
> +<para> To export a buffer, applicationis fill &v4l2-exportbuffer;.  The

applicationis -> applications

> +<structfield> type </structfield> field is set to the same buffer type as was
> +previously used with  &v4l2-requestbuffers;<structfield> type </structfield>.
> +Applications must also set the <structfield> index </structfield> field. Valid
> +index numbers range from zero to the number of buffers allocated with
> +&VIDIOC-REQBUFS; (&v4l2-requestbuffers;<structfield> count </structfield>)
> +minus one.  For multi plane API, applications set the <structfield> plane

"multi plane" -> "the multi-planar"

> +</structfield> field to the index of the plane to be exported. Valid planes
> +range from zero to the maximal number of valid planes for currently active

"for" -> "for the"

> +format. For single plane API, applications must set <structfield> plane

"single plane" -> "the single-planar"

> +</structfield> to zero.  Additional flags may be posted in the <structfield>
> +flags </structfield> field.  Refer to a manual for open() for details.
> +Currently only O_CLOEXEC is supported.  All other fields must be set to zero.
> +In a case of multi-planar API, every plane is exported separately using

"a case of" -> "the case of the"

> +multiple <constant> VIDIOC_EXPBUF </constant> calls. </para>
> +
> +<para> After calling <constant>VIDIOC_EXPBUF</constant> the <structfield> fd
> +</structfield> field will be set by a driver.  This is a DMABUF file
> +descriptor. The application may pass it to other API. Refer to <link

"API" -> "APIs"

or alternatively (and I like that better):

"API" -> "DMABUF-aware devices"

> +linkend="dmabuf">DMABUF importing</link> for details about importing DMABUF
> +files into V4L2 nodes. A developer is encouraged to close a DMABUF file when it
> +is no longer used to avoid a resource leak.  </para>

I'm not sure I like that last sentence. Perhaps something like this:

"It is recommended to close a DMABUF file when it is no longer used to allow
the associated memory to be reclaimed."

> +
> +  </refsect1>
> +  <refsect1>
> +   <section>
> +      <title>Examples</title>
> +
> +      <example>
> +	<title>Exporting a buffer.</title>
> +	<programlisting>
> +int buffer_export(int v4lfd, &v4l2-buf-type; bt, int index, int *dmafd)
> +{
> +	&v4l2-exportbuffer; expbuf;
> +
> +	memset(&amp;expbuf, 0, sizeof expbuf);

sizeof expbuf -> sizeof(expbuf)

> +	expbuf.type = bt;
> +	expbuf.index = index;
> +	if (ioctl(v4lfd, &VIDIOC-EXPBUF;, &amp;expbuf) == -1) {
> +		perror("VIDIOC_EXPBUF");
> +		return -1;
> +	}
> +
> +	*dmafd = expbuf.fd;
> +
> +	return 0;
> +}
> +        </programlisting>
> +      </example>
> +
> +      <example>
> +	<title>Exporting a buffer using multi plane API.</title>

"multi plane" -> "the multi-planar"

> +	<programlisting>
> +int buffer_export_mp(int v4lfd, &v4l2-buf-type; bt, int index,
> +	int dmafd[], int n_planes)
> +{
> +	int i;
> +
> +	for (i = 0; i &lt; n_planes; ++i) {
> +		&v4l2-exportbuffer; expbuf;
> +
> +		memset(&amp;expbuf, 0, sizeof expbuf);

sizeof(expbuf)

> +		expbuf.type = bt;
> +		expbuf.index = index;
> +		expbuf.plane = i;
> +		if (ioctl(v4lfd, &VIDIOC-EXPBUF;, &amp;expbuf) == -1) {
> +			perror("VIDIOC_EXPBUF");
> +			while (i)
> +				close(dmafd[--i]);
> +			return -1;
> +		}
> +		dmafd[i] = expbuf.fd;
> +	}
> +
> +	return 0;
> +}
> +        </programlisting>
> +      </example>
> +   </section>
> +  </refsect1>
> +
> +  <refsect1>
> +    <table pgwide="1" frame="none" id="v4l2-exportbuffer">
> +      <title>struct <structname>v4l2_exportbuffer</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__s32</entry>
> +	    <entry><structfield>fd</structfield></entry>
> +	    <entry>The DMABUF file descriptor associated with a buffer. Set by
> +		a driver.</entry>

a -> the

> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>flags</structfield></entry>
> +	    <entry>Flags for newly created file, currently only <constant>

for -> for the

> +O_CLOEXEC </constant> is supported, refer to the manual of open() for more
> +details.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>type</structfield></entry>
> +	    <entry>Type of the buffer, same as &v4l2-format;
> +<structfield>type</structfield> or &v4l2-requestbuffers;
> +<structfield>type</structfield>, set by the application. See <xref
> +linkend="v4l2-buf-type" /></entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>index</structfield></entry>
> +	    <entry>Number of the buffer, set by the application. This field is
> +only used for <link linkend="mmap">memory mapping</link> I/O and can range from
> +zero to the number of buffers allocated with the &VIDIOC-REQBUFS; ioctl

This really also includes any buffers allocated with VIDIOC_CREATE_BUFS.

> +(&v4l2-requestbuffers; <structfield>count</structfield>) minus one.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>plane</structfield></entry>
> +	    <entry>Index of the plane to be exported when using multi plane

multi plane -> the multi-planar

> +API. Otherwise this value must be set to zero. </entry>
> +	  </row>

Shouldn't type, index and plane comes first in this struct? That feels more
natural.

> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved[11]</structfield></entry>
> +	    <entry>Reserved field for future use. Must be set to zero.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>EINVAL</errorcode></term>
> +	<listitem>
> +	  <para>A queue is not in MMAP mode or DMABUF exporting is not
> +supported or <structfield> flags </structfield> or <structfield> type
> +</structfield> or <structfield> index </structfield> or <structfield> plane
> +</structfield> fields are invalid.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +
> +</refentry>
> 
